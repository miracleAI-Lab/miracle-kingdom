// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.11;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./libraries/GameLib.sol";
import "./CallerMgr.sol";

contract GameDB is Initializable, CallerMgr {
    using EnumerableSet for EnumerableSet.UintSet;
    
    // Skills learned by the hero
    mapping(uint256 => GameLib.LearnSkill[]) private _heroLearnSkills;
    // Hero attributes
    mapping(uint256 => GameLib.HeroMeta) private _tokenIndexHeroMetas;
    // Equipment information
    mapping(uint256 => GameLib.EquipmentMeta) private _tokenIndexEquipmentMetas;
    // All hero teams
    mapping(uint256 => GameLib.HeroTeam) private _heroTeams;
    // User's hero teams
    mapping(address => EnumerableSet.UintSet) private _userHeroTeams;
    // User equipment mapping (8 slots in total, equTypeId - 1 is the equipment worn in that slot)
    mapping(uint256 => uint256[8]) private _heroEquipments;
    // Hero Team Protection Time(heroTeamId => endTime)
    mapping(uint256 => uint256) private _heroTeamProtectionTimes;

    function initialize() public initializer {
        _setupCaller(msg.sender);
    }

    // Get hero information for the specified NFT
    function getHeroMeta(uint256 tokenId) public view returns (GameLib.HeroMeta memory meta) {
        meta = _tokenIndexHeroMetas[tokenId];
        meta.age = (block.timestamp - meta.joinTime) / 3600 * 24 * 30;
        if (meta.age == 0) {
            meta.age = 1;
        }
    }

    // Get NFT equipment information
    function getEquipmentMeta(uint256 tokenId) external view returns (GameLib.EquipmentMeta memory) {
        return _tokenIndexEquipmentMetas[tokenId];
    }

    // NFT hero information
    function setHeroMeta(GameLib.HeroMeta calldata meta) external onlyCaller {
        _tokenIndexHeroMetas[meta.tokenId] = meta;
    }

    // NFT equipment information
    function setEquipmentMeta(GameLib.EquipmentMeta calldata meta) external onlyCaller {
        _tokenIndexEquipmentMetas[meta.tokenId] = meta;
    }

    function setHeroTeam(GameLib.HeroTeam memory heroTeam) external onlyCaller {
        _heroTeams[heroTeam.id] = heroTeam;
    }

    function getHeroTeam(uint256 heroTeamId) external view returns (GameLib.HeroTeam memory) {
        return _heroTeams[heroTeamId];
    }

    function getHeroTeamMetas(uint256 heroTeamId) external view returns (GameLib.HeroMeta[] memory) {
        GameLib.HeroTeam memory heroTeam = _heroTeams[heroTeamId];
        GameLib.HeroMeta[] memory metas = new GameLib.HeroMeta[](3);
        if(heroTeam.id > 0) {
            for(uint i = 0; i < heroTeam.tokenIds.length; i++) {
                metas[i] = getHeroMeta(heroTeam.tokenIds[i]);
            }
        }

        return metas;
    }

    function deleteHeroTeam(uint256 heroTeamId) external onlyCaller {
        delete _heroTeams[heroTeamId];
    }

    function addUserHeroTeam(address owner, uint256 heroTeamId) external onlyCaller {
        _userHeroTeams[owner].add(heroTeamId);
    }

    function existsHeroTeam(address owner, uint256 heroTeamId) external view returns (bool) {
        return _userHeroTeams[owner].contains(heroTeamId);
    }

    function deleteUserHeroTeam(uint256 heroTeamId) external onlyCaller {
        _userHeroTeams[msg.sender].remove(heroTeamId);
    }

    // Get all teams by page
    function getHeroTeamsByPage(uint256 pageIndex, uint256 pageSize) public view returns (GameLib.HeroTeam[] memory) {
        GameLib.HeroTeam[] memory heroTeamList = new GameLib.HeroTeam[](pageSize);
        for (uint i = (pageIndex - 1) * pageSize; i < pageIndex * pageSize; i++) {
            GameLib.HeroTeam memory team = _heroTeams[i];
            if (team.id == 0) break;      
            heroTeamList[i] = team;   
        }

        return heroTeamList;
    }

    // Get the total number of user teams
    function getUserHeroTeamTotal(address owner) public view returns (uint256) {
        return _userHeroTeams[owner].values().length;
    }

    function getUserHeroTeams(address owner) public view returns (uint256[] memory) {
        return _userHeroTeams[owner].values();
    }

    function getUserHeroTeamsByPage(address owner, uint256 pageIndex, uint256 pageSize) public view returns (GameLib.HeroTeam[] memory) {
        uint256[] memory teamIds = _userHeroTeams[owner].values();
        GameLib.HeroTeam[] memory heroTeamList = new GameLib.HeroTeam[](pageSize);
        for (uint i = (pageIndex - 1) * pageSize; i < pageIndex * pageSize; i++) {
            if (i >= teamIds.length) break;
            GameLib.HeroTeam memory team = _heroTeams[teamIds[i]];
            if (team.id == 0) continue;
            heroTeamList[i] = team;
        }

        return heroTeamList;
    }

    // Get the equipment IDs of the specified hero NFT
    function getHeroEquipments(uint256 tokenId) external view returns (uint256[8] memory) {
        return _heroEquipments[tokenId];
    }

    // Get the equipment information of the specified hero NFT
    function getHeroEquipmentMetas(uint256 tokenId) external view returns (GameLib.EquipmentMeta[] memory) {
        uint256[8] memory equipments = _heroEquipments[tokenId];
        GameLib.EquipmentMeta[] memory metas = new GameLib.EquipmentMeta[](equipments.length);
        for (uint i = 0; i < equipments.length; i++) {
            if (equipments[i] == 0) {
                // No equipment
                continue;
            }
            metas[i] = _tokenIndexEquipmentMetas[equipments[i]];
        }

        return metas;
    }

    function getHeroLearnSkills(uint256 tokenId) external view returns (GameLib.LearnSkill[] memory) {
        return _heroLearnSkills[tokenId];
    }

    function getLearnSkill(uint256 tokenId, uint256 skillId) external view returns (GameLib.LearnSkill memory) {
        return _getLearnSkill(tokenId, skillId);
    }

    function _getLearnSkill(uint256 tokenId, uint256 skillId) internal view returns (GameLib.LearnSkill memory skill) {
        for (uint256 i = 0; i < _heroLearnSkills[tokenId].length; i++) {
            GameLib.LearnSkill memory ls = _heroLearnSkills[tokenId][i];
            if (ls.skillId == skillId) {
                return ls;
            }
        }
    }

    function learnSkill(uint256 tokenId, uint256 index, GameLib.LearnSkill calldata ls) external onlyCaller {
        if(ls.level > 1) {
            _heroLearnSkills[tokenId][index] = ls;
        } else {
            _heroLearnSkills[tokenId].push(ls);
        }
    }

    // Get all skills and skill levels of the hero
    function getHeroSkills(uint256 tokenId) external view returns (GameLib.LearnSkill[] memory) {
        return _heroLearnSkills[tokenId];
    }

    // Set equipment information for hero NFT
    function setHeroEquipments(uint256 tokenId, uint256[8] calldata equipments) external onlyCaller {
        _heroEquipments[tokenId] = equipments;
    }

    function setHeroTeamProtectionTime(uint256 heroTeamId, uint256 endTime) external onlyCaller {
        _heroTeamProtectionTimes[heroTeamId] = endTime;
    }

    function getHeroTeamProtectionTime(uint256 heroTeamId) external view returns (uint256) {
        return _heroTeamProtectionTimes[heroTeamId];
    }
}
