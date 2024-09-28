// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// for test
contract UsdtToken is Ownable, ERC20("USDT Token", "USDT") {

    constructor() {
        _mint(_msgSender(), 10000000000 * 1e18);
    }
}