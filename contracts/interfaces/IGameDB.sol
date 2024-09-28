// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../libraries/GameLib.sol";

interface IGameDB {
    function getHeroMeta(uint256 tokenId) external view returns (GameLib.HeroMeta memory);

    function getEquipmentMeta(uint256 tokenId) external view returns (GameLib.EquipmentMeta memory);

    function getHeroEquipments(uint256 tokenId) external view returns (uint256[8] memory);

    function setEquipmentMeta(GameLib.EquipmentMeta calldata meta) external;

    function setHeroMeta(GameLib.HeroMeta calldata meta) external;

    function setHeroEquipments(uint256 tokenId, uint256[8] calldata equTokenIds) external;

    function learnSkill(uint256 tokenId, uint256 index, GameLib.LearnSkill calldata ls) external;

    function deleteHeroTeam(uint256 heroTeamId) external;

    function existsHeroTeam(address owner, uint256 heroTeamId) external view returns (bool);

    function setHeroTeam(GameLib.HeroTeam memory heroTeam) external;

    function addUserHeroTeam(address owner, uint256 heroTeamId) external;

    function getHeroTeam(uint256 heroTeamId) external view returns (GameLib.HeroTeam memory);

    function deleteUserHeroTeam(uint256 heroTeamId) external;

    function getLearnSkill(uint256 tokenId, uint256 skillId) external view returns (GameLib.LearnSkill memory);

    function getHeroLearnSkills(uint256 tokenId) external view returns (GameLib.LearnSkill[] memory);

    function setHeroTeamProtectionTime(uint256 heroTeamId, uint256 endTime) external;

    function getHeroTeamProtectionTime(uint256 heroTeamId) external view returns (uint256);
}