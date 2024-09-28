// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../libraries/GameLib.sol";

interface IHeroFactory {
    function upHeroLevel(uint256 tokenId, bool isInsure, bool isLuckyPotion, uint256 luckyPotionId) external returns (bool);

    function generate(uint256 boxId, address to, uint256[] memory tokenIds) external returns (bool);

    function freeGenerate(address to, uint256 tokenId) external returns (bool);

    function getHeroLevel(uint256 tokenId) external view returns (uint8);

    function getHeroMeta(uint256 tokenId) external view returns (GameLib.HeroMeta memory);
}

