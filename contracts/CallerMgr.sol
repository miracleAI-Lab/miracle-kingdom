// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IBlast.sol";

contract CallerMgr is AccessControl {
    bytes32 public constant CALLER_ROLE = keccak256("CALLER_ROLE");

    constructor() {
        _setupCaller(msg.sender);
    }

    modifier onlyCaller() {
        require(hasRole(CALLER_ROLE, msg.sender), "MsgSender is not caller");
        _;
    }

    function _setupCaller(address caller) internal {
        _setupRole(CALLER_ROLE, caller);
    }

    // Set which contracts have permission to call the current contract.
    function setupCallers(address[] calldata _callers) external onlyCaller {
        for (uint i = 0; i < _callers.length; i++) {
            _setupRole(CALLER_ROLE, _callers[i]);
        }
    }
}
