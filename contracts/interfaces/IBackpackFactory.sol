// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IBackpackFactory {
    function createBackpack(address owner) external returns (address backpackAddress);

    function claim(address token, uint256 amount) external;

    function transfer(address token, address from, address to, uint256 amount) external;
   
    function addBalance(uint256 tokenId, address owner, uint256 amount) external;

    function subBalance(uint256 tokenId, address owner, uint256 amount) external;

    function getBalance(uint256 tokenId, address owner) external view returns (uint256);

    function getUserBackpack(address owner) external view returns (address);

    function totalSupply(uint256 tokenId) external view returns (uint256);
}