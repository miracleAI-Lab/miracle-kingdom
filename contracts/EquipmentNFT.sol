// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "./libraries/GameLib.sol";
import "./libraries/ConstLib.sol";
import "./interfaces/IBackpackFactory.sol";
import "./interfaces/IGameDB.sol";
import "./interfaces/IGameDB2.sol";
import "./CallerUpgradeableMgr.sol";

error URIQueryForNonexistentToken();

contract EquipmentNFT is ERC721EnumerableUpgradeable, CallerUpgradeableMgr {
    using Strings for uint256;
    using EnumerableSet for EnumerableSet.UintSet;

    // ======== VRF ========
    string private _baseURIExtended;

    mapping(address => bool) private _approvedOperators;
    mapping(uint256 => uint256) private _tokenIdRequestIdMaps;
    mapping(uint256 => EnumerableSet.UintSet) private _requestIdTokenIdMaps;
    mapping(uint256 => uint256) private _tokenIdBoxIdMaps;

    uint256 private _randSeed;
    IGameDB private _gameDB;
    IGameDB2 private _gameDB2;
    IERC20 private _pMAIToken;
    IBackpackFactory private _backpackFactory;

    event OpenBlinBox(uint256 tokenId, uint256 career, uint256 rarity);

    function initialize(
        string memory _name,
        string memory _symbol,
        IGameDB gameDB,
        IGameDB2 gameDB2,
        IBackpackFactory backpackFactory,
        IERC20 pMAIToken
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __CallerUpgradeableMgr_init();

        _gameDB = gameDB;
        _gameDB2 = gameDB2;
        _backpackFactory = backpackFactory;
        _pMAIToken = pMAIToken;
    }

    function setOperators(address[] memory addrs, bool isOperator) external onlyCaller {
        for (uint256 index = 0; index < addrs.length; index++) {
            _approvedOperators[addrs[index]] = isOperator;
        }
    }

    function setBaseURI(string memory __baseURI) external onlyCaller {
        _baseURIExtended = __baseURI;
    }

    // Forge equipment
    function mint(uint256 equipId, uint256[] memory gemstones, address owner) external onlyCaller {
        uint256 tokenId = totalSupply() + 1;
        _safeMint(owner, tokenId);
        _generate(tokenId, equipId, gemstones, owner);
    }

    // Generate attributes for forged equipment NFTs.
    function _generate(
        uint256 tokenId, 
        uint256 equipId, 
        uint256[] memory gemstones,
        address owner
    ) internal {
        GameLib.Equipment memory equipment = _gameDB2.getEquipment(equipId);
        GameLib.EquipmentMeta memory meta;
        meta.inlayNum = equipment.inlayNum;
        meta.gemstones = gemstones;
        require(meta.gemstones[0] + meta.gemstones[1] + meta.gemstones[2] <= meta.inlayNum, "Exceeded the maximum number of inlays");

        // The materials consumed in forging equipment.
        for (uint i = 0; i < equipment.material.length; i++) {
            uint256 propId = equipment.material[i];
            uint256 propNum = equipment.materialNum[i];
            _backpackFactory.subBalance(propId, owner, propNum);
        }

        // The consumption of embedded gems.
        _backpackFactory.subBalance(ConstLib.RED_GEM_STONE, owner, meta.gemstones[0]);
        _backpackFactory.subBalance(ConstLib.BLUE_GEM_STONE, owner, meta.gemstones[1]);
        _backpackFactory.subBalance(ConstLib.YELLOW_GEM_STONE, owner, meta.gemstones[2]);

        _pMAIToken.transferFrom(msg.sender, address(this), equipment.fee);

        meta.name = equipment.name;
        meta.equipId = equipment.id;
        meta.tokenId = tokenId;
        meta.typeId = equipment.typeId;     // Equipment type
        meta.careers = equipment.careers;     // Hero profession
        meta.minLevel = equipment.minLevel; // Required level
        meta.durable = equipment.durable;
        meta.unit = equipment.unit;
        meta.star = equipment.star;

        uint256 seeds = tokenId + equipId + gemstones.length + 1;
        uint256 valueStart = equipment.mainValues[0]; // Minimum main attribute
        uint256 valueEnd = equipment.mainValues[1];   // Maximum main attribute
        meta.mainValues = new uint256[](2);
        meta.mainValues[0] = GameLib.getRandxNum(seeds, valueStart, valueEnd); // Minimum random main attribute
        meta.mainValues[1] = valueEnd;
        meta.valueType = equipment.valueType;
        meta.quality = equipment.quality;
        meta.addStrength = meta.gemNum1 * 10;
        meta.addSpirit = meta.gemNum2 * 10;
        meta.addAgile = meta.gemNum3 * 10;
        meta.gemNum1 = gemstones[0];
        meta.gemNum2 = gemstones[1];
        meta.gemNum3 = gemstones[2];
        meta.image = _getImageURL(meta.equipId);
        _gameDB.setEquipmentMeta(meta);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        GameLib.EquipmentMeta memory meta = _gameDB.getEquipmentMeta(tokenId);
        bytes memory dataURI = abi.encodePacked(
            '{"image": "', _getImageURL(meta.equipId), '"}'
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }

    function _getImageURL(uint256 equipId) private pure returns (string memory) {
        return string(abi.encodePacked("/", equipId, ".png"));
    }

    function isApprovedForAll(address owner, address operator) public view override(ERC721Upgradeable) returns (bool) {
        return _approvedOperators[operator] || super.isApprovedForAll(owner, operator);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721EnumerableUpgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function getOwnerTokenIds(address owner) public view returns (uint256[] memory tokens) {
        tokens = new uint256[](balanceOf(owner));
        for (uint256 index = 0; index < tokens.length; index++) {
            tokens[index] = tokenOfOwnerByIndex(owner, index);
        }
    }

    function getOwnerEquipmentMetas(address owner) public view returns (GameLib.EquipmentMeta[] memory tokens) {
        tokens = new GameLib.EquipmentMeta[](balanceOf(owner));
        for (uint256 index = 0; index < tokens.length; index++) {
            tokens[index] = _gameDB.getEquipmentMeta(tokenOfOwnerByIndex(owner, index));
        }
    }

    // Get user equipment NFT list data by page.
    function getOwnerEquipmentMetasByPage(address owner, uint256 pageIndex, uint256 pageSize) public view returns (GameLib.EquipmentMeta[] memory tokens) {
        uint256 maxNum = balanceOf(owner);
        tokens = new GameLib.EquipmentMeta[](pageSize);
        for (uint index = (pageIndex - 1) * pageSize; index < pageIndex * pageSize; index++) {
            if (index >= maxNum) break;
            tokens[index] = _gameDB.getEquipmentMeta(tokenOfOwnerByIndex(owner, index));
        }
    }

    function getEquipmentMeta(uint256 _tokenId) public view returns (GameLib.EquipmentMeta memory) {
        return _gameDB.getEquipmentMeta(_tokenId);
    }
}
