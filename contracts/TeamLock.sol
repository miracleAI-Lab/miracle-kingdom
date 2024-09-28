// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TeamLock {
    IERC20 public coreToken;
    address public multSigAddress;
    
    constructor(address _multSigAddress, IERC20 _coreToken) {
        multSigAddress = _multSigAddress;
        coreToken = _coreToken;
    }

    modifier onlyMultSig() {
        require(msg.sender == multSigAddress, "MsgSender not is multSigAddress");
        _;
    }

    function withdraw(address to, uint256 amount) public onlyMultSig {
        uint256 bal = coreToken.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        coreToken.transfer(to, amount);
    }
}


