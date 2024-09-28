// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// Import necessary OpenZeppelin contracts and interfaces
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "./libraries/GameLib.sol";
import "./libraries/ConstLib.sol";
import "./interfaces/IBackpackFactory.sol";
import "./interfaces/IGameDB.sol";
import "./interfaces/IGameDB2.sol";
import "./interfaces/IFeeAccount.sol";
import "./CallerUpgradeableMgr.sol";

// Error for querying URI of non-existent token
error URIQueryForNonexistentToken();

// Library for HeroNFT specific errors
library HeroNFTErrors {
    error IncorrectSender();
    error InsufficientFee();
}

// Main HeroNFT contract
contract HeroNFT is ERC721EnumerableUpgradeable, ReentrancyGuardUpgradeable, CallerUpgradeableMgr {
    using Strings for uint256;
    using EnumerableSet for EnumerableSet.UintSet;

    // Struct to store buy NFT order details
    struct BuyNftOrder {
        address owner;
        address referrer;
        uint256 amount;
        uint256 reward;
        uint256 nftNum;
        uint256 timestamp;
    }

    // Mappings for various functionalities
    mapping(address => bool) private _approvedOperators;
    mapping(uint256 => uint256) private _tokenIdBoxIdMaps;
    mapping(address => address) private _referrers;
    mapping(uint256 => BuyNftOrder) private _buyNftOrder;

    // Arrays for rarity and level related data
    uint256[] private _rarityNum;
    uint256[] private _rarityPower;
    uint256[] private _rarityUpgrade;
    uint256[] private _levelRank;
    uint256[] private _raritys;

    // Various contract state variables
    uint256 private _randSeed;
    IFeeAccount private _feeAccount;
    IGameDB private _gameDB;
    IGameDB2 private _gameDB2;
    IBackpackFactory private _backpackFactory;
    IERC20 private _pMAIToken;
    bytes32 private _buySeed;

    string private _baseURIExtended;
    bool public startBuyNft;
    uint256 public orderNo;
    uint256 public nftPrice;

    // Error for VRF coordinator
    error OnlyCoordinatorCanFulfill(address have, address want);

    // Events
    event OpenBlinBox(uint256 tokenId, uint256 career, uint256 rarity);
    event LearnSkill(uint256 tokenId, uint256 skills);
    event HeroUpgrade(uint256 tokenId, uint256 level);
    event SetReferrer(address owner, address referrer);
    event BuyHeroNFT(uint256 orderNo, address owner, address referrer, uint256 amount, uint256 reward, uint256 nftNum);

    // Modifiers
    modifier validNFTOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "NFT is not owner of you");
        _;
    }

    modifier validNFTOwnerForHeroTeam(uint256 heroTeamId, uint256 tokenId) {
        address owner = msg.sender;
        require(_gameDB.existsHeroTeam(msg.sender, heroTeamId), "Team id does not belong to you");

        bool exists = false;
        GameLib.HeroTeam memory heroTeam = _gameDB.getHeroTeam(heroTeamId);
        for(uint i = 0; i < heroTeam.tokenIds.length; i++) {
            if(heroTeam.tokenIds[i] == tokenId) {
                exists = true;
                break;
            }
        }

        require(exists, "HeroNFT doesn't belong to you");
        _;
    }

    // Initialize function for the upgradeable contract
    function initialize(
        string memory _name,
        string memory _symbol,
        IFeeAccount feeAccount,
        IGameDB gameDB,
        IGameDB2 gameDB2,
        IBackpackFactory backpackFactory,
        IERC20 pMAIToken
    ) public initializer {
        __ERC721_init(_name, _symbol);
        __CallerUpgradeableMgr_init();
        _feeAccount = feeAccount;
        _gameDB = gameDB;
        _gameDB2 = gameDB2;
        _backpackFactory = backpackFactory;
        _pMAIToken = pMAIToken;
        _rarityPower = [550, 600, 650, 750, 850];
        _rarityUpgrade = [11, 12, 13, 15, 17];
        _levelRank = [0, 5, 10, 15, 20, 30];
        _rarityNum = [0, 0, 0, 0, 0, 0, 0];
        _raritys = [39, 28, 21, 10, 2];
        nftPrice = 1000 * 1e18;
    }

    // Set base URI for the NFTs
    function setBaseURI(string memory __baseURI) external onlyCaller {
        _baseURIExtended = __baseURI;
    }

    // Internal function to mint NFTs
    function mint(uint256 seed, uint256 quantity, address _mintTo) private returns (uint256[] memory)  {
        uint256 _lastId = totalSupply() + 1;
        uint256[] memory tokenIds = new uint256[](quantity);
        for (uint256 index = 0; index < quantity; index++) {
            uint256 tokenId =  _lastId + index;
            tokenIds[index] = tokenId;

            _safeMint(_mintTo, tokenId);
        }

        _generate(seed, tokenIds);

        return tokenIds;
    }

    // Hero upgrade for hero team
    function heroUpgradeForHeroTeam(uint256 heroTeamId, uint256 tokenId) external validNFTOwnerForHeroTeam(heroTeamId, tokenId) {
        _heroUpgrade(tokenId);
    }

    // Hero upgrade
    function heroUpgrade(uint256 tokenId) external validNFTOwner(tokenId) {
        _heroUpgrade(tokenId);
    }

    // Internal function for hero upgrade
    function _heroUpgrade(uint256 tokenId) private {
        GameLib.HeroMeta memory nftMeta = _gameDB.getHeroMeta(tokenId);
        GameLib.UpgradeExperience memory upgradeExperience = _gameDB2.getUpgradeExperiences()[nftMeta.level - 1];
        require(nftMeta.experience >= upgradeExperience.experience, "Experience points do not meet upgrade requirements");
        require(nftMeta.level < _levelRank[_levelRank.length - 1], "Level already Max");

        // Upgrade and deduct main token
        _pMAIToken.transferFrom(msg.sender, address(this), upgradeExperience.fee);
        _feeAccount.transferToFeeTreasury(upgradeExperience.fee);

        nftMeta.level += 1;
        // Calculate rank (iron, bronze, silver, gold, king)
        for (uint i = 1; i < _levelRank.length; i++) {
            if (nftMeta.level > _levelRank[i - 1] && nftMeta.level <= _levelRank[i]) {
                nftMeta.rank = i;
                break;
            }
        }
        if (nftMeta.level >= 20 && nftMeta.level <= 30) {
            nftMeta.star = (nftMeta.level - 20) / 2;
        }

        _gameDB.setHeroMeta(nftMeta);

        emit HeroUpgrade(tokenId, nftMeta.level);
    }

    // Learn skill for hero team
    function learnSkillForHeroTeam(uint256 heroTeamId, uint256 tokenId, uint256 skillId) external validNFTOwnerForHeroTeam(heroTeamId, tokenId) {
        _learnSkill(tokenId, skillId);
    }

    // Learn skill
    function learnSkill(uint256 tokenId, uint256 skillId) external validNFTOwner(tokenId) {
        _learnSkill(tokenId, skillId);
    }

    // Internal function for learning skill
    function _learnSkill(uint256 tokenId, uint256 skillId) private {
        GameLib.Skill memory skill = _gameDB2.getSkill(skillId);
        require(skill.id > 0, "Skills don't exist");
        GameLib.HeroMeta memory nftMeta = _gameDB.getHeroMeta(tokenId);
        require(nftMeta.career == skill.career, "Career mismatch");

        // Upgrade 0 -> 1 to 0, 1 -> 2 to 1, 2 -> 3 to 2
        uint256 index;
        GameLib.LearnSkill memory lSkill;
        GameLib.LearnSkill[] memory heroLearnSkills = _gameDB.getHeroLearnSkills(tokenId);
        for(uint256 i = 0; i < heroLearnSkills.length; i++) {
           if (heroLearnSkills[i].skillId == skillId) {
               lSkill = heroLearnSkills[i];
               index = i;
               break;
           }
        }

        _pMAIToken.transferFrom(msg.sender, address(this), skill.fees[lSkill.level]);

        uint256 skillLevel = lSkill.level;
        uint256 reqLevel = skill.heroReqLevels[skillLevel];
        require(nftMeta.level >= reqLevel, "Level Insufficient");
        require(skillLevel < skill.maxLevel, "Skill level exceed");
        if (lSkill.skillId > 0) {
           // Learned
           lSkill.level++;
        } else {
           // Not learned
           lSkill.level = 1;
           lSkill.skillId = skillId;
        }

        _gameDB.learnSkill(tokenId, index, lSkill);
        emit LearnSkill(tokenId, skillId);
    }

    // Generate multiple heroes
    function _generate(uint256 _seed, uint256[] memory tokenIds) internal returns (bool) {
        for (uint i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            _generateCallback(tokenId, _seed + tokenId + i);
        }

        return true;
    }

    // Generate a single hero
    function _generateCallback(uint256 tokenId, uint256 _seed) private {
        uint256 rarity = 0;
        uint256 probability = 0; 
        uint256 randNum = GameLib.getRandxNum(_seed + tokenId + 1, 1, 100);
        for (uint i = 0; i < _raritys.length; i++) {
            probability += _raritys[i];
            if (randNum <= probability) {
                rarity = i + 1;
                break;
            }
        }

        // Calculate probability. If the probability of the randomly drawn rarity exceeds the set probability, take a lower quality rarity
        uint256 rarityNum = _rarityNum[rarity];
        uint256 rarityTotalNum = _rarityNum[0];
        if (
            rarityTotalNum > 0 && 
            rarityNum * 100 / rarityTotalNum >= _raritys[rarity-1] && rarity > 1
        ) {
            rarity--;
        }

        _rarityNum[0] += 1;

        require(rarity > 0, "_generateCallback err");
        _generateHero(tokenId, rarity, _seed);
    }

    // Generate hero attributes
    function _generateHero(uint256 tokenId, uint256 rarity, uint256 _seed) private {
        _seed += tokenId + rarity + 1;
        GameLib.HeroMeta memory nftMeta = _gameDB.getHeroMeta(tokenId);
        nftMeta.tokenId = tokenId;
        nftMeta.rarity = rarity;

        // Randomly generate career
        uint256 num = GameLib.getRandxNum(_seed, 1, 100);
        if (num <= 33) {
            nftMeta.career = 1;
        } else if (num <= 66) {
            nftMeta.career = 2;
        } else {
            nftMeta.career = 3;
        }

        // Randomly generate gender
        nftMeta.gender = GameLib.getRandxNum(_seed, 1, 2);

        nftMeta.skinId = 1; // Default skin 1
        nftMeta.level = 1; // Default level 1
        nftMeta.rank = 1; // Default rank 1
        nftMeta.age = 1;        // Age
        nftMeta.joinTime = block.timestamp;// Join time

        // Randomly generate combat power value based on rarity
        uint256 maxPower =  _rarityPower[rarity-1];
        uint256 minPower = maxPower - 50;
        _seed += tokenId + minPower + maxPower + nftMeta.career + nftMeta.rarity;
        nftMeta.power = GameLib.getRandxNum(_seed, minPower+1, maxPower);
        nftMeta = getMetaInfo(nftMeta);
        nftMeta.image = _getHeroImage(nftMeta);
        _gameDB.setHeroMeta(nftMeta);

        emit OpenBlinBox(tokenId, nftMeta.career, nftMeta.rarity);
    }

    // Generate hero-related attributes based on the power attribute according to the role formula
    function getMetaInfo(GameLib.HeroMeta memory nftMeta) private pure returns (GameLib.HeroMeta memory) {
        if (nftMeta.career == ConstLib.WARRIOR) {
            nftMeta.strength = nftMeta.power*90/68;
            nftMeta.attack = nftMeta.power;
            nftMeta.spirit = nftMeta.power*3/50;     
            nftMeta.agile = nftMeta.power*7/20;      
            nftMeta.defense = nftMeta.power/5;   
            nftMeta.hitPoint = nftMeta.power * 280/100;
        } else if (nftMeta.career == ConstLib.MAGE) {
            nftMeta.strength = nftMeta.power*2/50;
            nftMeta.attack = nftMeta.power*120/100;
            nftMeta.spirit = nftMeta.power*90/68;     
            nftMeta.agile = nftMeta.power*8/20;      
            nftMeta.defense = nftMeta.power/8;   
            nftMeta.hitPoint = nftMeta.power * 120/100;     
        } else if (nftMeta.career == ConstLib.ASSASSIN) {
            nftMeta.strength = nftMeta.power*5/50;
            nftMeta.attack = nftMeta.power*110/100;
            nftMeta.spirit = nftMeta.power*5/50;     
            nftMeta.agile = nftMeta.power*90/68;      
            nftMeta.defense = nftMeta.power/7;   
            nftMeta.hitPoint = nftMeta.power*150/100;
        }  

        return nftMeta;
    }

    // Generate NFT URI with equipment
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        GameLib.HeroMeta memory meta = _gameDB.getHeroMeta(tokenId);
        bytes memory dataURI = abi.encodePacked(
            '{"image": "', _getHeroImage(meta), '"}'
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }

    // Generate a matching URI based on the hero's equipment
    function _getHeroImage(GameLib.HeroMeta memory meta) private view returns (string memory) {
        return string(abi.encodePacked(_baseURIExtended, "/", meta.career, "-", meta.skinId, "-", meta.gender, ".png"));
    }

    // Override isApprovedForAll function
    function isApprovedForAll(address owner, address operator) public view override(ERC721Upgradeable) returns (bool) {
        return _approvedOperators[operator] || super.isApprovedForAll(owner, operator);
    }

    // Override supportsInterface function
    function supportsInterface(bytes4 interfaceId) public view override(AccessControlUpgradeable, ERC721EnumerableUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Get token IDs owned by an address
    function getOwnerTokenIds(address owner) public view returns (uint256[] memory tokens) {
        tokens = new uint256[](balanceOf(owner));
        for (uint256 index = 0; index < tokens.length; index++) {
            tokens[index] = tokenOfOwnerByIndex(owner, index);
        }
    }

    // Get hero metas owned by an address
    function getOwnerHeroMetas(address owner) public view returns (GameLib.HeroMeta[] memory tokens) {
        tokens = new GameLib.HeroMeta[](balanceOf(owner));
        for (uint256 index = 0; index < tokens.length; index++) {
            tokens[index] = _gameDB.getHeroMeta(tokenOfOwnerByIndex(owner, index));
        }
    }

    // Get user hero NFT list data by page
    function getOwnerHeroMetasByPage(address owner, uint256 pageIndex, uint256 pageSize) public view returns (GameLib.HeroMeta[] memory tokens) {
        uint256 maxNum = balanceOf(owner);
        tokens = new GameLib.HeroMeta[](pageSize);
        for (uint index = (pageIndex - 1) * pageSize; index < pageIndex * pageSize; index++) {
            if (index >= maxNum) break;
            tokens[index] = _gameDB.getHeroMeta(tokenOfOwnerByIndex(owner, index));
        }
    }

    // Get hero meta for a specific token ID
    function getHeroMeta(uint256 _tokenId) public view returns (GameLib.HeroMeta memory) {
        return _gameDB.getHeroMeta(_tokenId);
    }

    // Get level hero metas for a specific token ID
    function getLevelHeroMetas(uint256 _tokenId) public view returns (GameLib.HeroMeta[] memory _heroMetas) {
        GameLib.HeroMeta memory meta = _gameDB.getHeroMeta(_tokenId);
        if (meta.level > 1) {
            meta.power = meta.power + meta.power * meta.level * _rarityUpgrade[meta.rarity - 1] / 100;
        }

        meta = getMetaInfo(meta);
        _heroMetas = new GameLib.HeroMeta[](2);
        _heroMetas[0] = _gameDB.getHeroMeta(_tokenId);
        _heroMetas[1] = meta;
    }

    // Set referrer for an address
    function _setReferrer(address owner, address referrer) private {
        _referrers[owner] = referrer;

        emit SetReferrer(owner, referrer);
    }

    // Get referrer for an address
    function getReferrer(address owner) public view returns (address) {
        return _referrers[owner];
    }

    // Start buying NFTs
    function startBuy() public onlyCaller {
        startBuyNft = true;
    }

    // Buy NFTs
    function buy(uint256 num, address referrer, bytes32 nextSeed) public nonReentrant {
        require(startBuyNft, "Buy nft is stop");
        require(_buySeed != nextSeed, "The seed cannot be the same as last seed");

        address owner = msg.sender;
        address _referrer = getReferrer(owner);
        if (_referrer == address(0)) {
            _setReferrer(owner, referrer);
            _referrer = referrer;
        }

        uint256 amount = nftPrice * num;
        mint(uint256(_buySeed), num, owner);

        _pMAIToken.transferFrom(owner, address(this), amount);
        uint256 reward = amount / 10;
        _feeAccount.transfer(_referrer, reward);
        // Transfer the remaining amount to the team
        _feeAccount.transferToFeeTreasury(amount - reward);

        orderNo++;
        _buyNftOrder[orderNo] = BuyNftOrder(owner, _referrer, amount, reward, num, block.timestamp);
        _buySeed = nextSeed;

        emit BuyHeroNFT(orderNo, owner, _referrer, amount, reward, num);
    }

    // Set NFT price
    function setNftPrice(uint256 price) public onlyCaller {
        nftPrice = price;
    }

    // Get buy seed
    function getBuySeed() public view onlyCaller returns (bytes32)  {
        return _buySeed;
    }

    // Set buy seed
    function setBuySeed(bytes32 buySeed) public onlyCaller {
        _buySeed = buySeed;
    }
}