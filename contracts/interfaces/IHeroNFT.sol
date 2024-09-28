// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../libraries/GameLib.sol";

interface IHeroNFT {
    function mint(uint256 boxRarity, uint256 quantity, address _mintTo) external;

    function freemint(uint256 quantity, address _mintTo) external;

    function getHeroLevel(uint256 tokenId) external view returns (uint8);

    function getHeroMeta(uint256 tokenId) external view returns (GameLib.HeroMeta memory);
}
