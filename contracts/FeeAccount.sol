// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ISharePool.sol";
import "./CallerMgr.sol";

contract FeeAccount is CallerMgr {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    IERC20 private _mainToken;
    ISharePool private _sharePool;
    address private _treasury;
    
    constructor(IERC20 mainToken, ISharePool sharePool, address treasury) {
        _mainToken = mainToken;
        _sharePool = sharePool;
        _treasury = treasury;
    }

    function addRewardsToSharePool(uint256 sharePoolAmount) public onlyCaller {
        _mainToken.approve(address(_sharePool), type(uint256).max);
        _sharePool.addRewards(sharePoolAmount);
    }

    function transfer(address to, uint256 amount) public onlyCaller {
        uint256 bal = _mainToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        _mainToken.transfer(to, amount);
    }

    function transferToFeeTreasury(uint256 amount) public onlyCaller {
        uint256 bal = _mainToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        _mainToken.transfer(_treasury, amount);
    }

    function withdraw(address to, uint256 amount) public onlyCaller {
        uint256 bal = _mainToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        _mainToken.transfer(to, amount);
    }

    // Set Manager function
    function setManager(address[] calldata callers) external onlyCaller() {
        for(uint i = 0; i < callers.length; i++) {
            _setupRole(MANAGER_ROLE, callers[i]);
        }
    }

    function setSharePool(ISharePool sharePool) public onlyCaller {
        _sharePool = sharePool;
    }

    function setTreasury(address treasury) public onlyCaller {
        _treasury = treasury;
    }
}


