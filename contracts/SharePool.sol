// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// Import necessary libraries and interfaces
import "./libraries/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/IBackpackFactory.sol";
import "./libraries/ConstLib.sol";
import "./CallerMgr.sol";

// SharePool contract for managing rewards distribution
contract SharePool is ReentrancyGuard, Ownable, CallerMgr {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    // Struct to store user information
    struct UserInfo {
        uint256 gold;
        uint256 shares;
        uint256 rewardDebt;
    }

    // Struct to store rewards pool information
    struct RewardsPool {
        IERC20 token;
        uint256 totalGold;
        uint256 rewardAmount; // Total rewards to distribute
        uint256 remainingAmount; // Remaining rewards to distribute
        uint256 accRewardsPerShare;
        uint256 totalShares;
        uint256 lastRewardTime;
        uint256 endTime;
    }

    bool public started;
    uint256 public startTime;
    mapping(address => UserInfo) public userInfo;
    RewardsPool public rewardsPool;
    uint256 public constant SECOND_PER_YEAR = 31536000; //63072000
    IBackpackFactory private _backpackFactory;

    // Events
    event Deposit(address userAddress, uint256 amount);
    event Harvest(address userAddress, address rewardsToken, uint256 pending);
    event Withdraw(address userAddress, address rewardsToken, uint256 amount);

    // Constructor to initialize the contract
    constructor(IERC20 _rewardsPool, IBackpackFactory backpackFactory) {
        rewardsPool.token = _rewardsPool;
        _backpackFactory = backpackFactory;

        _setupCaller(msg.sender);
    }

    // Function to start the rewards distribution
    function start() public onlyOwner {
        started = true;
        startTime = block.timestamp;
        rewardsPool.endTime = 1742267218;
        _updatePool();
    }

    // Calculate shares based on gold amount and time
    function getSwapShares(uint256 goldAmount) public view returns (uint256 shares) {
        uint256 x = 9e10 / SECOND_PER_YEAR;
        uint256 sec = block.timestamp - startTime;
        shares = goldAmount.add(goldAmount.mul(x.mul(sec)).div(1e10));
    }

    // Calculate rewards token per second
    function rewardsTokenPerSecond() public view returns (uint256) {
        if (rewardsPool.endTime <= rewardsPool.lastRewardTime) return 0;
        return rewardsPool.remainingAmount.div(rewardsPool.endTime.sub(rewardsPool.lastRewardTime));
    }

    // Add rewards to the pool
    function addRewards(uint256 amountToken) external nonReentrant {
        IERC20(rewardsPool.token).safeTransferFrom(msg.sender, address(this), amountToken);
        rewardsPool.rewardAmount = rewardsPool.rewardAmount.add(amountToken);
        rewardsPool.remainingAmount = rewardsPool.remainingAmount.add(amountToken);

        _updatePool();
    }

    // Deposit gold to earn rewards
    function deposit(uint256 amount) external nonReentrant {
        require(started, "Deposit not start");
        _updatePool();

        address owner = msg.sender;
        _backpackFactory.subBalance(ConstLib.GOLD_COIN, owner, amount);
        UserInfo storage user = userInfo[owner];
        _harvest(owner);

        uint256 shares = getSwapShares(amount);
        user.gold = user.gold.add(amount);
        user.shares = user.shares.add(shares);
        rewardsPool.totalGold = rewardsPool.totalGold.add(amount);
        rewardsPool.totalShares = rewardsPool.totalShares.add(shares);
        _updateRewardDebt(owner);

        emit Deposit(owner, amount);
    }

    // Harvest rewards
    function harvest() external nonReentrant {
        address owner = msg.sender;
        _updatePool();
        _harvest(owner);
        _updateRewardDebt(owner);
    }

    // Update user's reward debt
    function _updateRewardDebt(address owner) internal {
        UserInfo storage user = userInfo[owner];
        user.rewardDebt = user.shares.mul(rewardsPool.accRewardsPerShare);
    }

    // Update the rewards pool
    function _updatePool() internal {
        uint256 currentBlockTimestamp = block.timestamp;
        if (currentBlockTimestamp <= rewardsPool.lastRewardTime) return;

        if (rewardsPool.totalShares == 0) {
            rewardsPool.lastRewardTime = currentBlockTimestamp;
            return;
        }

        uint256 rewardsAmount = rewardsTokenPerSecond().mul(currentBlockTimestamp.sub(rewardsPool.lastRewardTime));
        if (rewardsAmount > rewardsPool.remainingAmount) rewardsAmount = rewardsPool.remainingAmount;
        rewardsPool.remainingAmount = rewardsPool.remainingAmount.sub(rewardsAmount);
        rewardsPool.accRewardsPerShare = rewardsPool.accRewardsPerShare.add(rewardsAmount.div(rewardsPool.totalShares));
        rewardsPool.lastRewardTime = currentBlockTimestamp;
    }

    // Internal function to harvest rewards
    function _harvest(address owner) internal {
        uint256 pending = getPendingRewards(owner);
        _safeRewardsTransfer(rewardsPool.token, owner, pending);

        emit Harvest(owner, address(rewardsPool.token), pending);
    }

    // Get pending rewards for an account
    function getPendingRewards(address account) public view returns (uint256 pendding) {
        UserInfo memory user = userInfo[account];
        pendding = user.shares.mul(rewardsPool.accRewardsPerShare).sub(user.rewardDebt);
    }

    // Safely transfer rewards
    function _safeRewardsTransfer(IERC20 token, address to, uint256 amount) internal {
        if(amount == 0) return;
        uint256 balance = token.balanceOf(address(this));
        if (amount > balance) {
            amount = balance;
        }
        token.transfer(to, amount);
    }

    // Set the end time for rewards distribution
    function setEndTime(uint256 endTime) public onlyCaller {
        rewardsPool.endTime = endTime;
    }
}