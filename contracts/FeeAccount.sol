// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ISharePool.sol";
import "./CallerMgr.sol";

// Contract for managing fees and rewards distribution
contract FeeAccount is CallerMgr {
    // Role identifier for managers
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    // Main token used for fees and rewards
    IERC20 private _mainToken;
    // Share pool contract for distributing rewards
    ISharePool private _sharePool;
    // Treasury address for storing fees
    address private _treasury;
    
    // Constructor to initialize the contract with necessary addresses
    constructor(IERC20 mainToken, ISharePool sharePool, address treasury) {
        _mainToken = mainToken;
        _sharePool = sharePool;
        _treasury = treasury;
    }

    // Add rewards to the share pool
    function addRewardsToSharePool(uint256 sharePoolAmount) public onlyCaller {
        _mainToken.approve(address(_sharePool), type(uint256).max);
        _sharePool.addRewards(sharePoolAmount);
    }

    // Transfer tokens to a specified address
    function transfer(address to, uint256 amount) public onlyCaller {
        uint256 bal = _mainToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        _mainToken.transfer(to, amount);
    }

    // Transfer tokens to the fee treasury
    function transferToFeeTreasury(uint256 amount) public onlyCaller {
        uint256 bal = _mainToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        _mainToken.transfer(_treasury, amount);
    }

    // Withdraw tokens to a specified address
    function withdraw(address to, uint256 amount) public onlyCaller {
        uint256 bal = _mainToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        _mainToken.transfer(to, amount);
    }

    // Set manager roles for multiple addresses
    function setManager(address[] calldata callers) external onlyCaller() {
        for(uint i = 0; i < callers.length; i++) {
            _setupRole(MANAGER_ROLE, callers[i]);
        }
    }

    // Update the share pool address
    function setSharePool(ISharePool sharePool) public onlyCaller {
        _sharePool = sharePool;
    }

    // Update the treasury address
    function setTreasury(address treasury) public onlyCaller {
        _treasury = treasury;
    }
}

