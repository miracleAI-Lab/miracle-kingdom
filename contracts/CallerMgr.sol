// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IBlast.sol";

// Contract for managing caller permissions
contract CallerMgr is AccessControl {
    // Define a constant for the caller role
    bytes32 public constant CALLER_ROLE = keccak256("CALLER_ROLE");

    // Constructor: Set up the contract deployer as the initial caller
    constructor() {
        _setupCaller(msg.sender);
    }

    // Modifier to restrict access to only approved callers
    modifier onlyCaller() {
        require(hasRole(CALLER_ROLE, msg.sender), "MsgSender is not caller");
        _;
    }

    // Internal function to set up a new caller
    function _setupCaller(address caller) internal {
        _setupRole(CALLER_ROLE, caller);
    }

    // External function to set up multiple callers at once
    // Only existing callers can add new callers
    function setupCallers(address[] calldata _callers) external onlyCaller {
        for (uint i = 0; i < _callers.length; i++) {
            _setupRole(CALLER_ROLE, _callers[i]);
        }
    }
}
