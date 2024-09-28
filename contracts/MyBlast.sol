// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IBlast.sol";

contract MyBlast is AccessControl {
    bytes32 public constant CALLER_ROLE = keccak256("CALLER_ROLE");

    address public constant pointsOperatorAddress = 0x4300000000000000000000000000000000000002;        
    IBlast public constant BLAST = IBlast(0x4300000000000000000000000000000000000002);
    IBlastPoints public constant blastPoints = IBlastPoints(0x2fc95838c71e76ec69ff817983BFf17c710F34E0);
    IERC20Rebasing public constant USDB = IERC20Rebasing(0x4300000000000000000000000000000000000003);
    IERC20Rebasing public constant WETH = IERC20Rebasing(0x4300000000000000000000000000000000000004);
    IERC20 public usdbToken;
    IERC20 public wethToken;

    modifier onlyCaller() {
        require(hasRole(CALLER_ROLE, msg.sender), "MsgSender is not caller");
        _;
    }

    function configureBlast() internal {
        _setupCaller(msg.sender);
        BLAST.configureClaimableGas();
        blastPoints.configurePointsOperator(pointsOperatorAddress);
    }

    function configureETHYield() internal {
        BLAST.configureAutomaticYield();
    }

    function configureUSDBYield() internal {
        usdbToken = IERC20(address(USDB));
        USDB.configure(YieldMode.AUTOMATIC); //configure claimable yield for USDB
    }

    function configureWETHYield() internal {
        wethToken = IERC20(address(WETH));
        WETH.configure(YieldMode.AUTOMATIC); //configure claimable yield for USDB
    }

    function claimMyContractsGas(address recipient) external onlyCaller {
        BLAST.claimAllGas(address(this), recipient);
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
