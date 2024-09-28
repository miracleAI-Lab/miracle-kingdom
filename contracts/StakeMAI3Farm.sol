// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./libraries/ConstLib.sol";
import "./CallerMgr.sol";

// Contract for staking MAI3 tokens and earning rewards
contract StakeMAI3Farm is Ownable, ReentrancyGuard, CallerMgr {
    // Information about the staking pool
    struct PoolInfo {
        IERC20 stakeToken; // Address of the token to be staked
        IERC20 rewardToken; // Address of the reward token
        uint256 totaStaked;  // Total amount currently staked
        uint256 totalReward; // Total rewards distributed
        uint256 duration;
        uint256 apy;
        uint256 stakeDays; // Staking period in days
    }

    // Information about a user's stake
    struct UserInfo {
        uint256 unlockTime;  // Time when the stake can be withdrawn
        uint256 stakeAmount;  // Amount staked
        uint256 totalReward; // Total rewards claimed
        uint256 rewardPerSecond; // Rewards earned per second
        uint256 lastRewardTime; // Last time rewards were claimed
        uint256 startTime; // Time of the first deposit
    }

    // Array of staking pools
    PoolInfo[] private _poolInfo;
    // Mapping of user stakes for each pool
    mapping(uint256 => mapping(address => UserInfo)) private _userInfo;
    bool private _startStaked;
    IERC20 private mai3Token;

    // Events
    event Deposit(address indexed user, uint256 indexed poolId, uint256 _days, uint256 amount);
    event Claim(address indexed user, uint256 indexed poolId, uint256 _days, uint256 stakedAmount, uint256 reward);
    event Withdraw(address indexed user, uint256 indexed poolId, uint256 _days, uint256 stakedAmount, uint256 reward);

    constructor(IERC20 _mai3Token) {
        mai3Token = _mai3Token;
        _setupCaller(msg.sender);
    }

    // Add a new staking pool
    function addPool(IERC20 stakeToken, IERC20 rewardToken, uint256 stakeDays, uint256 apy) public onlyCaller {
        PoolInfo memory pool;
        pool.stakeToken = stakeToken;
        pool.rewardToken = rewardToken;
        pool.stakeDays = stakeDays;
        pool.apy = apy;
        _poolInfo.push(pool);
    }

    // Enable or disable staking
    function setStartStaked(bool startStaked) public onlyCaller {
        _startStaked = startStaked;
    }

    // Check if staking is enabled
    function getStartStaked() external view returns (bool) {
        return _startStaked;
    }

    // Calculate rewards per second based on amount and APY
    function getRewardPerSecond(uint256 amount, uint256 apy) public pure returns (uint256) {
        return amount * apy / 100 / (ConstLib.SECONDS_PER_DAY * 365);
    }

    // Deposit tokens into a staking pool
    function deposit(uint256 poolId, uint256 amount) public nonReentrant {  
        require(_startStaked, "Stake not start!");
        require(amount > 0, "Stake amount can not be 0!");

        PoolInfo storage pool = _poolInfo[poolId];
        UserInfo storage user = _userInfo[poolId][msg.sender];
        pool.stakeToken.transferFrom(msg.sender, address(this), amount);

        if (user.stakeAmount == 0) {
            user.stakeAmount += amount;
            user.rewardPerSecond = getRewardPerSecond(user.stakeAmount, pool.apy);
            user.startTime = block.timestamp;
            user.unlockTime = user.startTime + ConstLib.SECONDS_PER_DAY * pool.duration;
        } else {
            // Claim pending rewards before updating stake
            uint256 pendingReward = getPendingReward(user);
            pool.totalReward += pendingReward;
            pool.rewardToken.transfer(msg.sender, pendingReward);

            // Recalculate rewards per second with new stake amount
            user.stakeAmount += amount;
            user.rewardPerSecond = getRewardPerSecond(user.stakeAmount, pool.apy);
        }
        user.lastRewardTime = block.timestamp;

        // Update total staked amount in the pool
        pool.totaStaked += amount;
        
        emit Deposit(msg.sender, poolId, pool.stakeDays, amount);
    }

    // Internal function to claim rewards
    function _claim(uint256 poolId) private {
        UserInfo storage user = _userInfo[poolId][msg.sender];
        require(user.stakeAmount > 0, "stake amount must be > 0");

        // Calculate pending rewards
        uint256 pendingReward = getPendingReward(user);
        PoolInfo storage pool = _poolInfo[poolId];
        if(pendingReward > 0) {
            // Update total rewards in the pool
            pool.totalReward += pendingReward;
            // Update user's total rewards
            user.totalReward += pendingReward;
            // Update last reward time
            user.lastRewardTime = block.timestamp;
            // Transfer rewards to user
            safeTransfer(pool.rewardToken, msg.sender, pendingReward);
        }

        emit Claim(msg.sender, poolId, pool.stakeDays, user.stakeAmount, pendingReward);
    }

    // Claim rewards from a specific pool
    function claim(uint256 poolId) public nonReentrant {
        _claim(poolId);
    }

    // Claim rewards from all pools
    function claimAll() public nonReentrant {
        for(uint poolId = 0; poolId < _poolInfo.length; poolId++) {
            _claim(poolId);
        }
    }

    // Withdraw stake and rewards
    function withdraw(uint256 poolId) public nonReentrant {
        UserInfo storage user = _userInfo[poolId][msg.sender];
        require(user.stakeAmount > 0, "stake amount must be > 0");
        require(block.timestamp >= user.unlockTime, "unlock time not invalid");

        // Calculate pending rewards
        uint256 pendingReward = getPendingReward(user);
        PoolInfo storage pool = _poolInfo[poolId];
        if(pendingReward > 0) {
            // Update total rewards in the pool
            pool.totalReward += pendingReward;
            // Update user's total rewards
            user.totalReward += pendingReward;
            // Update last reward time
            user.lastRewardTime = block.timestamp;
            // Transfer rewards to user
            safeTransfer(pool.rewardToken, msg.sender, pendingReward);
        }
        // Update total staked amount in the pool
        pool.totaStaked -= user.stakeAmount;
        // Transfer stake back to user
        safeTransfer(pool.stakeToken, msg.sender, user.stakeAmount);

        emit Withdraw(msg.sender, poolId, pool.stakeDays, user.stakeAmount, pendingReward);

        delete _userInfo[poolId][msg.sender];
    }

    // Get information about all pools
    function getAllPools() public view returns (PoolInfo[] memory) {
       return _poolInfo;
    }

    // Get user's stake information for a specific pool
    function getStakedInfo(uint256 poolId, address owner) public view returns (UserInfo memory users) {
        users = _userInfo[poolId][owner];
    }

    // Get user's stake information for all pools
    function getAllStakedInfo(address owner) public view returns (UserInfo[] memory stakedInfos) {
        stakedInfos = new UserInfo[](_poolInfo.length);
        for (uint i = 0; i < _poolInfo.length; i++) {
            stakedInfos[i] = _userInfo[i][owner];
        }
    }

    // Get pending rewards for a user in a specific pool
    function penddingRewardByPoolId(address owner, uint256 poolId) public view returns (uint256) {
        return getPendingReward(_userInfo[poolId][owner]);
    }

    // Get pending rewards for a specific stake
    function pendingRewardByStakeId(address owner, uint256 poolId) public view returns (uint256) {
        return getPendingReward(_userInfo[poolId][owner]);
    }

    // Calculate pending rewards for a user
    function getPendingReward(UserInfo memory user) internal view returns (uint256 pendingReward) {
        uint256 diffSeconds = block.timestamp - user.lastRewardTime;
        pendingReward = diffSeconds * user.rewardPerSecond;
    }

    // Safe transfer function to handle edge cases
    function safeTransfer(IERC20 token, address _to, uint256 amount) internal {
        uint256 bal = token.balanceOf(address(this));
        if (amount > bal) {
            token.transfer(_to, bal);
        } else {
            token.transfer(_to, amount);
        }
    }
}
