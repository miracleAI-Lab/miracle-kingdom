// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PMaiToken is ERC20("Play for MAI3", "pMAI3"), Ownable {

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}