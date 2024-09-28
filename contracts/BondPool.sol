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

contract BondPool is ReentrancyGuard, Ownable, CallerMgr {
    using EnumerableSet for EnumerableSet.UintSet;

    // 债券
    struct Bond {
        uint256 apy; // 利率
        uint256 lockDays; // 锁仓天数
        uint256 price; // 价格
        bool isActive; // 是否激活
        uint256 totalSupply; // 总供应
        uint256 currentSupply; // 当前供应
    }

    // 用户债券
    struct UserBond {
        address owner;
        uint256 goldAmount;
        uint256 rewardAmount;
        uint256 startBlockNumber;
        uint256 unlockBlockNumber;
        bool isClaim;
    }

    IERC20 private _mai3Token;
    uint256 public rewardPerGold; // 每枚金币的奖励
    Bond[] private _bonds;
    IBackpackFactory private _backpackFactory;
    uint256 public _userBondId;
    // All user bonds
    mapping(uint256 => UserBond) private _allUserBonds;
    // User's bonds
    mapping(address => EnumerableSet.UintSet) private _userBonds;
    uint256 private _maxApy = 200;
    uint256 private _maxRewardPerGold = 1e18;

    event Exchange(address userAddress, uint256 bondId);
    event Claim(address userAddress, uint256 userBondId);

    constructor(IERC20 mai3Token, IBackpackFactory backpackFactory) {
        _mai3Token = mai3Token;
        _backpackFactory = backpackFactory;
        _setupCaller(msg.sender);
    }

    function addBond(Bond memory bond) public onlyCaller {
        require(bond.totalSupply > 0, "TotalSupply must be greater than 0 ");
        require(bond.apy < _maxApy, "Apy must be less than maxApy");
        bond.currentSupply = 0;
        _bonds.push(bond);
    }

    function getBonds() public returns (Bond[] memory) {
        return _bonds;
    }

    function setIsActive(uint256 bondId, bool isActive) public onlyCaller {
        _bonds[bondId].isActive = isActive;
    }

    function setMaxApy(uint256 maxApy) public onlyCaller {
        _maxApy = maxApy;
    }

    function addRewards(uint256 amount) public onlyCaller {
        _mai3Token.transferFrom(msg.sender, address(this), amount);
        _updatePool();
    }

    function updatePool() public onlyCaller {
        _updatePool();
    }

    function _updatePool() internal {
        uint256 bal = _mai3Token.balanceOf(address(this));
        uint256 goldSupply = _backpackFactory.totalSupply(ConstLib.GOLD_COIN);
        rewardPerGold = bal / goldSupply;
        if(rewardPerGold > _maxRewardPerGold) rewardPerGold = _maxRewardPerGold;
    }

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

    function getUserBond(uint256 userBondId) public view returns (UserBond memory) {
        return _allUserBonds[userBondId];
    }

    function getUserBondsByPage(address owner, uint256 pageIndex, uint256 pageSize) public view returns (UserBond[] memory) {
        uint256[] memory ids = _userBonds[owner].values();
        UserBond[] memory userBonds = new UserBond[](pageSize);
        for (uint i = (pageIndex - 1) * pageSize; i < pageIndex * pageSize; i++) {
            if (i >= ids.length) break;
            userBonds[i] = _allUserBonds[ids[i]];
        }

        return userBonds;
    }

    function getBondsByPage(uint256 pageIndex, uint256 pageSize) public view returns (Bond[] memory) {
        Bond[] memory bonds = new Bond[](pageSize);
        for (uint i = (pageIndex - 1) * pageSize; i < pageIndex * pageSize; i++) {
            if (i >= _bonds.length) break;
            bonds[i] = _bonds[i];
        }

        return bonds;
    }

    function getTotalUserBond(address owner) public view returns (uint256) {
        return _userBonds[owner].values().length;
    }
}