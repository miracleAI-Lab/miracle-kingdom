// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./libraries/ConstLib.sol";
import "./CallerMgr.sol";

contract StakeMAI3Farm is Ownable, ReentrancyGuard, CallerMgr {
    // 存款池子信息
    struct PoolInfo {
        IERC20 stakeToken; // 存款token地址
        IERC20 rewardToken; // 奖励token地址
        uint256 totaStaked;  // 当前总质押
        uint256 totalReward; // 总奖励
        uint256 duration;
        uint256 apy;
        uint256 stakeDays; // 质押天数
    }

    // 用户存款信息
    struct UserInfo {
        uint256 unlockTime;  // 解锁时间
        uint256 stakeAmount;  // 存款金额
        uint256 totalReward; // 领取奖励
        uint256 rewardPerSecond; // 每秒奖励
        uint256 lastRewardTime; // 上一次领取奖励时间
        uint256 startTime; // 第一次存款时间
    }

    // 存款池子数组
    PoolInfo[] private _poolInfo;
    // 存储用户在池子下的存款记录
    mapping(uint256 => mapping(address => UserInfo)) private _userInfo;
    bool private _startStaked;
    IERC20 private mai3Token;

    event Deposit(address indexed user, uint256 indexed poolId, uint256 _days, uint256 amount);
    event Claim(address indexed user, uint256 indexed poolId, uint256 _days, uint256 stakedAmount, uint256 reward);
    event Withdraw(address indexed user, uint256 indexed poolId, uint256 _days, uint256 stakedAmount, uint256 reward);

    constructor(IERC20 _mai3Token) {
        mai3Token = _mai3Token;
        _setupCaller(msg.sender);
    }

    // 添加池子，参数：存款token的合约，奖励token的合约
    function addPool(IERC20 stakeToken, IERC20 rewardToken, uint256 stakeDays, uint256 apy) public onlyCaller {
        PoolInfo memory pool;
        pool.stakeToken = stakeToken;
        pool.rewardToken = rewardToken;
        pool.stakeDays = stakeDays;
        pool.apy = apy;
        _poolInfo.push(pool);
    }

    // 设置开启质押
    function setStartStaked(bool startStaked) public onlyCaller {
        _startStaked = startStaked;
    }

     // 获取是否开启质押
    function getStartStaked() external view returns (bool) {
        return _startStaked;
    }

    function getRewardPerSecond(uint256 amount, uint256 apy) public view returns (uint256) {
        return amount * apy / 100 / (ConstLib.SECONDS_PER_DAY * 365);
    }

    // 存款金额到某个池子
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
            // 先提取上次利息
            uint256 pendingReward = getPendingReward(user);
            pool.totalReward += pendingReward;
            pool.rewardToken.transfer(msg.sender, pendingReward);

            // 金额改变了，重新计算每秒收益
            user.stakeAmount += amount;
            user.rewardPerSecond = getRewardPerSecond(user.stakeAmount, pool.apy);
        }
        user.lastRewardTime = block.timestamp;

        // 池子总存款金额
        pool.totaStaked += amount;
        
        emit Deposit(msg.sender, poolId, pool.stakeDays, amount);
    }

    function _claim(uint256 poolId) private {
        UserInfo storage user = _userInfo[poolId][msg.sender];
        require(user.stakeAmount > 0, "stake amount must be > 0");

        // 实时计算利息
        uint256 pendingReward = getPendingReward(user);
        PoolInfo storage pool = _poolInfo[poolId];
        if(pendingReward > 0) {
            // 记录池子下所有用户已领取的奖励
            pool.totalReward += pendingReward;
            // 记录用户已领取的奖励
            user.totalReward += pendingReward;
            // 记录下本次领取奖励的区块时间，方便计算实时奖励
            user.lastRewardTime = block.timestamp;
            // 利息转给用户
            safeTransfer(pool.rewardToken, msg.sender, pendingReward);
        }

        emit Claim(msg.sender, poolId, pool.stakeDays, user.stakeAmount, pendingReward);
    }

    // 领取池子下某个存款的实时利息收益
    function claim(uint256 poolId) public nonReentrant {
        _claim(poolId);
    }

    function claimAll() public nonReentrant {
        for(uint poolId = 0; poolId < _poolInfo.length; poolId++) {
            _claim(poolId);
        }
    }

    // 取回本金加利息
    function withdraw(uint256 poolId) public nonReentrant {
        UserInfo storage user = _userInfo[poolId][msg.sender];
        require(user.stakeAmount > 0, "stake amount must be > 0");
        require(block.timestamp >= user.unlockTime, "unlock time not invalid");

        // 先计算用户的利息奖励
        uint256 pendingReward = getPendingReward(user);
        PoolInfo storage pool = _poolInfo[poolId];
        if(pendingReward > 0) {
            // 记录池子下所有用户已领取的奖励
            pool.totalReward += pendingReward;
            // 记录用户已领取的奖励
            user.totalReward += pendingReward;
            // 记录下本次领取奖励的区块时间，方便计算实时奖励
            user.lastRewardTime = block.timestamp;
            // 利息转给用户
            safeTransfer(pool.rewardToken, msg.sender, pendingReward);
        }
        // 池子下总存款金额减少当前用户的本金
        pool.totaStaked -= user.stakeAmount;
        // 本金转给用户
        safeTransfer(pool.stakeToken, msg.sender, user.stakeAmount);

        emit Withdraw(msg.sender, poolId, pool.stakeDays, user.stakeAmount, pendingReward);

        delete _userInfo[poolId][msg.sender];
    }

    // 获取所有池子信息
    function getAllPools() public view returns (PoolInfo[] memory) {
       return _poolInfo;
    }

    // 获取用户在某池子下所有的存款记录
    function getStakedInfo(uint256 poolId, address owner) public view returns (UserInfo memory users) {
        users = _userInfo[poolId][owner];
    }

    // 获取用户在所有池子下所有的存款记录
    function getAllStakedInfo(address owner) public view returns (UserInfo[] memory stakedInfos) {
        stakedInfos = new UserInfo[](_poolInfo.length);
        for (uint i = 0; i < _poolInfo.length; i++) {
            stakedInfos[i] = _userInfo[i][owner];
        }
    }

    // 实时获取用户在某池子下所有存款记录的总利息收益
    function penddingRewardByPoolId(address owner, uint256 poolId) public view returns (uint256) {
        return getPendingReward(_userInfo[poolId][owner]);
    }

    // 实时获取用户在某个池子下某条存款的利息收益
    function pendingRewardByStakeId(address owner, uint256 poolId) public view returns (uint256) {
        return getPendingReward(_userInfo[poolId][owner]);
    }

    function getPendingReward(UserInfo memory user) internal view returns (uint256 pendingReward) {
        uint256 diffSeconds = block.timestamp - user.lastRewardTime;
        pendingReward = diffSeconds * user.rewardPerSecond;
    }

    // 转账
    function safeTransfer(IERC20 token, address _to, uint256 amount) internal {
        uint256 bal = token.balanceOf(address(this));
        if (amount > bal) {
            token.transfer(_to, bal);
        } else {
            token.transfer(_to, amount);
        }
    }
}
