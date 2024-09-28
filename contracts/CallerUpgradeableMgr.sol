// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

// Upgradeable caller management contract
contract CallerUpgradeableMgr is AccessControlUpgradeable {
    // Constant for the caller role
    bytes32 public constant CALLER_ROLE = keccak256("CALLER_ROLE");

    // Modifier to restrict access to only callers
    modifier onlyCaller() {
        require(hasRole(CALLER_ROLE, msg.sender), "MsgSender is not caller");
        _;
    }

    // Initialization function
    function __CallerUpgradeableMgr_init() internal {
        // Initialize access control
        __AccessControl_init_unchained();
        // Set the contract deployer as the initial caller
        _setupCaller(msg.sender);
    }

    // Internal function: set up a caller
    function _setupCaller(address caller) internal {
        _setupRole(CALLER_ROLE, caller);
    }

    // External function: set up calling permissions for multiple contracts
    // Only existing callers can add new callers
    function setupCallers(address[] calldata _callers) external onlyCaller {
        for (uint i = 0; i < _callers.length; i++) {
            _setupRole(CALLER_ROLE, _callers[i]);
        }
    }
}