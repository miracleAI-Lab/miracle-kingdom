// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./interfaces/IBackpackFactory.sol";
import "./libraries/ConstLib.sol";
import "./CallerMgr.sol";

// Contract for managing bond pools
contract BondPool is ReentrancyGuard, Ownable, CallerMgr {
    using EnumerableSet for EnumerableSet.UintSet;

    // Bond structure
    struct Bond {
        uint256 apy; // Annual Percentage Yield
        uint256 lockDays; // Lock-up period in days
        uint256 price; // Price of the bond
        bool isActive; // Whether the bond is active
        uint256 totalSupply; // Total supply of the bond
        uint256 currentSupply; // Current supply of the bond
    }

    // User's bond structure
    struct UserBond {
        address owner; // Owner of the bond
        uint256 goldAmount; // Amount of gold invested
        uint256 rewardAmount; // Reward amount
        uint256 startBlockNumber; // Block number when the bond started
        uint256 unlockBlockNumber; // Block number when the bond can be unlocked
        bool isClaim; // Whether the reward has been claimed
    }

    IERC20 private _mai3Token; // MAI3 token contract
    uint256 public rewardPerGold; // Reward per unit of gold
    Bond[] private _bonds; // Array of all bonds
    IBackpackFactory private _backpackFactory; // Backpack factory contract
    uint256 public _userBondId; // Unique identifier for user bonds
    // Mapping of all user bonds
    mapping(uint256 => UserBond) private _allUserBonds;
    // Mapping of user's bonds
    mapping(address => EnumerableSet.UintSet) private _userBonds;
    uint256 private _maxApy = 200; // Maximum allowed APY
    uint256 private _maxRewardPerGold = 1e18; // Maximum reward per unit of gold

    event Exchange(address userAddress, uint256 bondId);
    event Claim(address userAddress, uint256 userBondId);

    // Constructor to initialize the contract
    constructor(IERC20 mai3Token, IBackpackFactory backpackFactory) {
        _mai3Token = mai3Token;
        _backpackFactory = backpackFactory;
        _setupCaller(msg.sender);
    }

    // Add a new bond to the pool
    function addBond(Bond memory bond) public onlyCaller {
        require(bond.totalSupply > 0, "TotalSupply must be greater than 0 ");
        require(bond.apy < _maxApy, "Apy must be less than maxApy");
        bond.currentSupply = 0;
        _bonds.push(bond);
    }

    // Get all bonds in the pool
    function getBonds() public view returns (Bond[] memory) {
        return _bonds;
    }

    // Set the active status of a bond
    function setIsActive(uint256 bondId, bool isActive) public onlyCaller {
        _bonds[bondId].isActive = isActive;
    }

    // Set the maximum APY
    function setMaxApy(uint256 maxApy) public onlyCaller {
        _maxApy = maxApy;
    }

    // Add rewards to the pool
    function addRewards(uint256 amount) public onlyCaller {
        _mai3Token.transferFrom(msg.sender, address(this), amount);
        _updatePool();
    }

    // Update the pool (public function)
    function updatePool() public onlyCaller {
        _updatePool();
    }

    // Internal function to update the pool
    function _updatePool() internal {
        uint256 bal = _mai3Token.balanceOf(address(this));
        uint256 goldSupply = _backpackFactory.totalSupply(ConstLib.GOLD_COIN);
        rewardPerGold = bal / goldSupply;
        if(rewardPerGold > _maxRewardPerGold) rewardPerGold = _maxRewardPerGold;
    }

    // Exchange gold for a bond
    function exchange(uint256 bondId) public {
        Bond storage bond = _bonds[bondId];
        require(bond.isActive, "Bond not active");
        require(bond.currentSupply < bond.totalSupply, "The current supply must be less than the total supply");

        _backpackFactory.subBalance(ConstLib.GOLD_COIN, msg.sender, bond.price);
        bond.currentSupply++;
        
        UserBond memory userBond;
        userBond.owner = msg.sender;
        userBond.goldAmount = bond.price;
        if(bond.lockDays == 0) {
            userBond.rewardAmount = rewardPerGold * bond.price / 2;
        } else {
            userBond.rewardAmount = rewardPerGold * bond.price * bond.apy / 100;
            userBond.rewardAmount += rewardPerGold * bond.price;
        }
        userBond.startBlockNumber = block.number;
        userBond.unlockBlockNumber = block.number + bond.lockDays * ConstLib.SECONDS_PER_DAY;

        _userBondId++;
        _allUserBonds[_userBondId] = userBond;
        _userBonds[msg.sender].add(_userBondId);

        _updatePool();

        emit Exchange(userBond.owner, bondId);
    }

    // Claim rewards for a bond
    function claim(uint256 userBondId) public nonReentrant {
        UserBond storage userBond = _allUserBonds[userBondId];
        require(msg.sender == userBond.owner, "Bond not belong to you");
        require(block.number >= userBond.unlockBlockNumber, "The unlocking time is not up");
        require(!userBond.isClaim, "Non repeatability Claim");

        userBond.isClaim = true;
        _userBonds[userBond.owner].remove(userBondId);
        _mai3Token.transfer(userBond.owner, userBond.rewardAmount);

        _updatePool();

        emit Claim(userBond.owner, userBondId);
    }

    // Get a specific user bond
    function getUserBond(uint256 userBondId) public view returns (UserBond memory) {
        return _allUserBonds[userBondId];
    }

    // Get user bonds by page
    function getUserBondsByPage(address owner, uint256 pageIndex, uint256 pageSize) public view returns (UserBond[] memory) {
        uint256[] memory ids = _userBonds[owner].values();
        UserBond[] memory userBonds = new UserBond[](pageSize);
        for (uint i = (pageIndex - 1) * pageSize; i < pageIndex * pageSize; i++) {
            if (i >= ids.length) break;
            userBonds[i] = _allUserBonds[ids[i]];
        }

        return userBonds;
    }

    // Get bonds by page
    function getBondsByPage(uint256 pageIndex, uint256 pageSize) public view returns (Bond[] memory) {
        Bond[] memory bonds = new Bond[](pageSize);
        for (uint i = (pageIndex - 1) * pageSize; i < pageIndex * pageSize; i++) {
            if (i >= _bonds.length) break;
            bonds[i] = _bonds[i];
        }

        return bonds;
    }

    // Get total number of user bonds
    function getTotalUserBond(address owner) public view returns (uint256) {
        return _userBonds[owner].values().length;
    }
}