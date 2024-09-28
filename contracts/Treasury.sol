// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Treasury {
    IERC20 public usdtToken;
    IERC20 public coreToken;
    address public multSigAddress;
    
    constructor(address _multSigAddress, IERC20 _usdtToken, IERC20 _coreToken) {
        multSigAddress = _multSigAddress;
        usdtToken = _usdtToken;
        coreToken = _coreToken;
    }

    modifier onlyMultSig() {
        require(msg.sender == multSigAddress, "MsgSender not is multSigAddress");
        _;
    }

    function withdrawWithType(uint tokenType, address to, uint256 amount) public onlyMultSig {
        IERC20 token = tokenType == 1 ? usdtToken : coreToken;
        uint256 bal = token.balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        token.transfer(to, amount);
    }

    function withdraw(address tokenAddr, address to, uint256 amount) public onlyMultSig {
        uint256 bal = IERC20(tokenAddr).balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        IERC20(tokenAddr).transfer(to, amount);
    }
}


