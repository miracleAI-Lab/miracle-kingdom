// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IEquipmentNFT {
    // Purchase a blind box and immediately open it
    function mint(uint256 equipId, uint256[] memory gemstones) external;

    // Get the owner of the equipment
    function ownerOf(uint256 tokenId) external view returns (address);

    // Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    // Casting
    function mint(uint256 equipId, uint256[] calldata gemstones, address to) external;
}