// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Backpack.sol";
import "./CallerUpgradeableMgr.sol";

interface IBackpack {
    function claim(address owner, address token, uint256 amount) external;

    function transfer(address token, address to, uint256 amount) external;

    function addBalance(uint256 token, uint256 amount) external;

    function subBalance(uint256 token, uint256 amount) external;

    function getBalance(uint256 token) external view returns (uint256);

    function getAllBalances() external view returns (uint256[] memory);
}

contract BackpackFactory is Initializable, CallerUpgradeableMgr {
    address[] private _users;
    mapping(address => address) private _userBackpacks;
    mapping(uint256 => uint256) private _maxSupply;
    mapping(uint256 => uint256) private _totalSupply;
    mapping(address => bool) private _manager;

    event CreateBackpack(address owner, address backpack);
    event Claim(address tokenId, address owner, address backpack, uint256 amount);
    event AddBalance(uint256 tokenId, address owner, address backpack, uint256 amount);
    event SubBalance(uint256 tokenId, address owner, address backpack, uint256 amount);

    function initialize() public initializer {
        __CallerUpgradeableMgr_init();
    }

    function hasBackpack(address owner) external view returns (bool) {
        return _userBackpacks[owner] != address(0);
    }

    function createBackpack(address owner) public onlyCaller returns (address backpackAddress) {
        backpackAddress = _createBackpack(owner);
    }

    function _createBackpack(address owner) internal returns (address backpackAddress) {
        require(_userBackpacks[owner] == address(0), "Backpack already exists!");

        Backpack backpack = new Backpack();
        backpackAddress = address(backpack);
        _userBackpacks[owner] = backpackAddress;
        _users.push(owner);

        emit CreateBackpack(owner, backpackAddress);
    }

    function claim(address token, uint256 amount) external {
        address owner = msg.sender;
        address backpack = _userBackpacks[owner];
        IBackpack(backpack).claim(owner, token, amount);

        emit Claim(token, owner, backpack, amount);
    }

    function transfer(address token, address from, address to, uint256 amount) external onlyCaller {
        address backpack = _userBackpacks[from];
        IBackpack(backpack).transfer(token, to, amount);
    }
   
    function addBalance(uint256 tokenId, address owner, uint256 amount) external onlyCaller {
        if (amount == 0) return;
        if (_userBackpacks[owner] == address(0)) {
            _createBackpack(owner);
        }

        address backpack = _userBackpacks[owner];
        IBackpack(backpack).addBalance(tokenId, amount);

        _maxSupply[tokenId] += amount;
        _totalSupply[tokenId] += amount; 
        
        emit AddBalance(tokenId, owner, backpack, amount);
    }

    function subBalance(uint256 tokenId, address owner, uint256 amount) external onlyCaller {
        if (amount == 0) return;
        if (_userBackpacks[owner] == address(0)) {
            _createBackpack(owner);
        }

        address backpack = _userBackpacks[owner];
        uint256 bal = IBackpack(backpack).getBalance(tokenId);
        require(bal >= amount, "Insufficient account balance");

        IBackpack(backpack).subBalance(tokenId, amount);
        _totalSupply[tokenId] -= amount;

        emit SubBalance(tokenId, owner, backpack, amount);
    }

    function getBalance(uint256 tokenId, address owner) external view returns (uint256) {
        address backpack = _userBackpacks[owner];
        if(backpack == address(0)) {
            return 0;
        }

        return IBackpack(backpack).getBalance(tokenId);
    }

    function getUserBackpack(address owner) external view returns (address) {
        return _userBackpacks[owner];
    }

    function getAllUsers() external view returns (address[] memory) {
        return _users;
    }

    function getAllBalances(address owner) external view returns (uint256[] memory bals) {
        address backpack = _userBackpacks[owner];
        if(backpack == address(0)) {
            return bals;
        }

        return IBackpack(backpack).getAllBalances();
    }

    function totalSupply(uint256 tokenId) external view returns (uint256) {
        return _totalSupply[tokenId];
    }

    function maxSupply(uint256 tokenId) external view returns (uint256) {
        return _maxSupply[tokenId];
    }
}
