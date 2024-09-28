// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../libraries/GameLib.sol";

interface IGameDB2 {
    function getBoxPrice(uint256 boxId) external view returns (uint256);

    function getEquipment(uint256 equipId) external view returns (GameLib.Equipment memory);

    function getUpgradeExperiences() external view returns (GameLib.UpgradeExperience[] memory);

    function getSkill(uint256 skillId) external view returns (GameLib.Skill memory);
}