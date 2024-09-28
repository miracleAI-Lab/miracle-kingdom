// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultDAO {
    address public multSigAddress;
    
    constructor(address _multSigAddress) {
        multSigAddress = _multSigAddress;
    }

    modifier onlyMultSig() {
        require(msg.sender == multSigAddress, "MsgSender not is multSigAddress");
        _;
    }

    function withdraw(address tokenAddr, address to, uint256 amount) public onlyMultSig {
        uint256 bal = IERC20(tokenAddr).balanceOf(address(this));
        if (bal < amount) {
            amount = bal;
        }

        IERC20(tokenAddr).transfer(to, amount);
    }
}


