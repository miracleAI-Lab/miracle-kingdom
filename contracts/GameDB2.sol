// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./libraries/GameLib.sol";
import "./CallerMgr.sol";

// Contract for storing and managing game data
contract GameDB2 is Initializable, CallerMgr {
    using EnumerableSet for EnumerableSet.UintSet;

    // Experience required for hero upgrades
    GameLib.UpgradeExperience[] private _upgradeExperiences;
    // Props (items) in the game
    GameLib.Prop[] private _props;
    // Skill template data
    GameLib.Skill[] private _skills;
    // Equipment template data
    GameLib.Equipment[] private _equipments;

    // Initialize the contract
    function initialize() public initializer {
        _setupCaller(msg.sender);
    }

    // Retrieves information about a specific item
    function getProp(uint256 propId) external view returns (GameLib.Prop memory) {
        return _props[propId - 1];
    }

    // Retrieves all item information
    function getProps() external view returns (GameLib.Prop[] memory) {
        return _props;
    }

    // Retrieves equipment template information
    function getEquipment(uint256 equipId) external view returns (GameLib.Equipment memory) {
        return _equipments[equipId - 1];
    }

    // Retrieves all equipment template information
    function getEquipments() external view returns (GameLib.Equipment[] memory) {
        return _equipments;
    }

    // Retrieves all experience required for upgrades
    function getUpgradeExperiences() external view returns (GameLib.UpgradeExperience[] memory) {
        return _upgradeExperiences;
    }

    // Sets the experience required for hero upgrades
    function setUpgradeExperiences(GameLib.UpgradeExperience[] calldata experiences) public onlyCaller {
        for (uint i = 0; i < experiences.length; i++) {
            _upgradeExperiences.push(experiences[i]);
        }
    }

    // Sets the skill template data
    function setSkills(GameLib.Skill[] calldata skills) public onlyCaller {
        for (uint i = 0; i < skills.length; i++) {
            _skills.push(skills[i]);
        }
    }

    // Sets a specific skill template data
    function setSkill(GameLib.Skill calldata skill) public onlyCaller {
        _skills[skill.id - 1] = skill;
    }

    // Retrieves all skill template data
    function getSkills() external view returns (GameLib.Skill[] memory) {
        return _skills;
    }

    // Retrieves specific skill template data
    function getSkill(uint256 skillId) external view returns (GameLib.Skill memory) {
        return _skills[skillId - 1];
    }

    // Adds new items to the game
    function addProps(GameLib.Prop[] calldata props) external onlyCaller {
        for (uint i = 0; i < props.length; i++) {
            _props.push(props[i]);
        }
    }

    // Updates an existing item's data
    function updateProp(GameLib.Prop calldata prop) external onlyCaller {
        for (uint i = 0; i < _props.length; i++) {
            GameLib.Prop memory p = _props[i];
            if (prop.id == p.id) {
              _props[i] = prop;
              break;
            }
        }
    }

    // Sets or updates a specific item's data
    function setProp(GameLib.Prop calldata prop) external onlyCaller {
        GameLib.Prop memory p = _props[prop.id - 1];
        if (prop.id == p.id) {
            _props[prop.id - 1] = prop;
        }
    }

    // Adds new equipment templates to the game
    function addEquipments(GameLib.Equipment[] calldata equipments) external onlyCaller {
        for (uint i = 0; i < equipments.length; i++) {
            _equipments.push(equipments[i]);
        }
    }

    // Updates an existing equipment template's data
    function updateEquipment(GameLib.Equipment calldata equipment) external onlyCaller {
        for (uint i = 0; i < _equipments.length; i++) {
            GameLib.Equipment memory p = _equipments[i];
            if (equipment.id == p.id) {
              _equipments[i] = equipment;
              break;
            }
        }
    }

    // Sets or updates a specific equipment template's data
    function setEquipment(GameLib.Equipment calldata equipment) external onlyCaller {
        GameLib.Equipment memory p = _equipments[equipment.id - 1];
        if (equipment.id == p.id) {
            _equipments[equipment.id - 1] = equipment;
        }
    }
}
