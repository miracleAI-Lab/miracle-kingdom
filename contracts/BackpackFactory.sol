// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Backpack.sol";
import "./CallerUpgradeableMgr.sol";

// Interface for the Backpack contract
interface IBackpack {
    function claim(address owner, address token, uint256 amount) external;
    function transfer(address token, address to, uint256 amount) external;
    function addBalance(uint256 token, uint256 amount) external;
    function subBalance(uint256 token, uint256 amount) external;
    function getBalance(uint256 token) external view returns (uint256);
    function getAllBalances() external view returns (uint256[] memory);
}

// Main contract for managing backpacks
contract BackpackFactory is Initializable, CallerUpgradeableMgr {
    address[] private _users;
    mapping(address => address) private _userBackpacks;
    mapping(uint256 => uint256) private _maxSupply;
    mapping(uint256 => uint256) private _totalSupply;
    mapping(address => bool) private _manager;

    // Events
    event CreateBackpack(address owner, address backpack);
    event Claim(address tokenId, address owner, address backpack, uint256 amount);
    event AddBalance(uint256 tokenId, address owner, address backpack, uint256 amount);
    event SubBalance(uint256 tokenId, address owner, address backpack, uint256 amount);

    // Initialize the contract
    function initialize() public initializer {
        __CallerUpgradeableMgr_init();
    }

    // Check if a user has a backpack
    function hasBackpack(address owner) external view returns (bool) {
        return _userBackpacks[owner] != address(0);
    }

    // Create a backpack for a user (only callable by authorized callers)
    function createBackpack(address owner) public onlyCaller returns (address backpackAddress) {
        backpackAddress = _createBackpack(owner);
    }

    // Internal function to create a backpack
    function _createBackpack(address owner) internal returns (address backpackAddress) {
        require(_userBackpacks[owner] == address(0), "Backpack already exists!");

        Backpack backpack = new Backpack();
        backpackAddress = address(backpack);
        _userBackpacks[owner] = backpackAddress;
        _users.push(owner);

        emit CreateBackpack(owner, backpackAddress);
    }

    // Claim tokens from the backpack
    function claim(address token, uint256 amount) external {
        address owner = msg.sender;
        address backpack = _userBackpacks[owner];
        IBackpack(backpack).claim(owner, token, amount);

        emit Claim(token, owner, backpack, amount);
    }

    // Transfer tokens from one backpack to another (only callable by authorized callers)
    function transfer(address token, address from, address to, uint256 amount) external onlyCaller {
        address backpack = _userBackpacks[from];
        IBackpack(backpack).transfer(token, to, amount);
    }
   
    // Add balance to a user's backpack (only callable by authorized callers)
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

    // Subtract balance from a user's backpack (only callable by authorized callers)
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

    // Get the balance of a specific token for a user
    function getBalance(uint256 tokenId, address owner) external view returns (uint256) {
        address backpack = _userBackpacks[owner];
        if(backpack == address(0)) {
            return 0;
        }

        return IBackpack(backpack).getBalance(tokenId);
    }

    // Get the backpack address for a user
    function getUserBackpack(address owner) external view returns (address) {
        return _userBackpacks[owner];
    }

    // Get all users with backpacks
    function getAllUsers() external view returns (address[] memory) {
        return _users;
    }

    // Get all balances for a user
    function getAllBalances(address owner) external view returns (uint256[] memory bals) {
        address backpack = _userBackpacks[owner];
        if(backpack == address(0)) {
            return bals;
        }

        return IBackpack(backpack).getAllBalances();
    }

    // Get the total supply of a specific token
    function totalSupply(uint256 tokenId) external view returns (uint256) {
        return _totalSupply[tokenId];
    }

    // Get the maximum supply of a specific token
    function maxSupply(uint256 tokenId) external view returns (uint256) {
        return _maxSupply[tokenId];
    }
}
