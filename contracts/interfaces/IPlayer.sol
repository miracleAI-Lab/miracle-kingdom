// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IPlayer {
    // One-time synchronization to set equipment, old equipment to be replaced is put into the remove equipment array, new equipment to be added is put into the add equipment array
    function setHeroEquipments(uint256 tokenId, uint256[] calldata typeIds, uint256[] calldata equTokenIds) external;

    function getHeroEquipments(uint256 tokenId) external view returns (uint256[] memory);

    function setFreemint(address owner) external;

    function getFreemint(address owner) external view returns (bool);

    function setReferrer(address owner, address referrer) external;

    function getReferrer(address owner) external view returns (address);
}