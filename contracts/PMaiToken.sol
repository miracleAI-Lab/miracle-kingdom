// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.11;

// Import OpenZeppelin contracts for ownership and ERC20 token standard
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// PMaiToken contract inheriting from ERC20 and Ownable
contract PMaiToken is ERC20("Play for MAI3", "pMAI3"), Ownable {

    // Function to mint new tokens
    // Only the owner can call this function
    // @param to The address that will receive the minted tokens
    // @param amount The amount of tokens to mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}