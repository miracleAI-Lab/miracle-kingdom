// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MaiToken is ERC20("Miracle AI", "MAI3") {

    constructor() {
        _mint(msg.sender, 1_000_000_000 * 1e18);
    }
}