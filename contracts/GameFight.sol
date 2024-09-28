// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.11;

// Importing required contracts and interfaces from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/SignatureCheckerUpgradeable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IBackpackFactory.sol";
import "./libraries/GameLib.sol";
import "./interfaces/IGameDB.sol";
import "./interfaces/IFeeAccount.sol";
import "./CallerUpgradeableMgr.sol";

// GameFight contract definition
contract GameFight is Initializable, ReentrancyGuardUpgradeable, EIP712Upgradeable, CallerUpgradeableMgr {
    using EnumerableSet for EnumerableSet.UintSet;

    // Game task structure definition
    struct GameTask {
        string name; // Name of the game task
        uint256 id; // Unique identifier for the game task
        uint256 maxPlayerNum; // Maximum number of participants allowed
        uint256 joinPlayerNum; // Current number of participants
        uint256 gameFee;   // Entrance fee for the game task
        uint256 totalFee;  // Total entrance fee income
        uint256 rank;      // Rank restriction for registration
        uint256 startTime; // Task start time
        uint256 endTime;   // Task end time
        uint256 taskType;  // Type of the task
        uint256 fightLimit; // Limit on the number of fights
        uint256 mapId; // ID of the map for the task
        uint256 round; // Round number of the task
        uint256[] rarities;  // Array of restricted card rarities
    }

    // Reward structure definition
    struct Reward {
        uint256 id; // Unique identifier for the reward
        uint256 num; // Number of rewards
    }

    // Fight record structure definition
    struct FightRecord {
        address owner; // Address of the player
        uint256 gameTaskId; // ID of the game task
        uint256 fightNo; // Fight number
        uint256 mapId; // ID of the map
        uint256 heroTeamId; // ID of the hero team
        uint256 experiences; // Experience gained from the fight
        bool claimed; // Whether the rewards have been claimed
    }

    // Private variables declaration
    IGameDB private _gameDB;
    IBackpackFactory private _backpackFactory;
    IFeeAccount private _feeAccount;
    IERC20 private _pMAI3Token;

    uint256 private _fightNo;
    uint256 private _gameTaskId;
    address private _signer;
    mapping(uint256 => FightRecord) private _fightRecords;
    mapping(uint256 => GameTask) private _gameTasks;
    mapping(address => uint256) private _lastFightNo;
    mapping(uint256 => EnumerableSet.UintSet) private _gameMembers;
    mapping(uint256 => bool) private _claimedTeamFee;
    // gameTaskId > heroTeamId > fightCount
    mapping(uint256 => mapping(uint256 => uint256)) private _gameFightCounts;
    mapping(uint256 => bool) private _nonces;

    // Fight event declaration
    event Fight(address owner, uint256 gameTaskId, uint256 fightNo, uint256 mapId, uint256 heroTeamId);
    // Claim rewards event declaration
    event ClaimRewards(address owner, uint256 gameTaskId, uint256 fightNo, uint256 mapId, uint256 heroTeamId);
    event ClaimRankRewards(address owner, uint256 gameTaskId, uint256 mapId, uint256 heroTeamId);
    event ClaimAirdropRewards(address owner, uint256 nonce, uint256 tokenAmount, uint256 point);

    // Initialize function
    function initialize(IGameDB gameDB, IBackpackFactory backpackFactory, IFeeAccount feeAccount, IERC20 pMAI3Token, address signer) public initializer {
        _gameDB = gameDB;
        _backpackFactory = backpackFactory;
        _feeAccount = feeAccount;
        _pMAI3Token = pMAI3Token;
        _signer = signer;
        __CallerUpgradeableMgr_init();
        __EIP712_init("GameFightSign", "1.0.0");
    }

    // Create game task function
    function createPlay(GameTask memory gameTask) public {
        _gameTaskId++;
        gameTask.id = _gameTaskId;
        _gameTasks[_gameTaskId] = gameTask;
    }

    // Withdraw game fee function
    function withdrawGameFee(uint256 gameTaskId, uint256 heroTeamId) public {
        require(_gameMembers[gameTaskId].length() < 10, "can't withdraw fee");
        require(_gameDB.existsHeroTeam(msg.sender, heroTeamId), "Team id does not belong to you");

        GameTask memory gameTask = _gameTasks[gameTaskId];
        require(block.timestamp > gameTask.endTime, "gameTask not end");
        require(_gameMembers[gameTaskId].contains(heroTeamId), "heroTeamId not exists");

        _feeAccount.transfer(msg.sender, gameTask.gameFee);
        _gameMembers[gameTaskId].remove(heroTeamId);
    }

    // Fight function
    function fight(uint256 gameTaskId, uint256 mapId, uint256 heroTeamId) public {
        require(_gameDB.existsHeroTeam(msg.sender, heroTeamId), "Team id does not belong to you");
        if (gameTaskId > 0) {
            GameTask memory gameTask = _gameTasks[gameTaskId];
            uint256 fightCount = _gameFightCounts[gameTaskId][heroTeamId];

            require(_gameTasks[gameTaskId].id > 0, "Game task is not exists");
            require(fightCount < gameTask.fightLimit, "Team reach fight limit");
            require(block.timestamp >= gameTask.startTime, "Game has started");
            require(block.timestamp <= gameTask.endTime, "Game is over");

            GameLib.HeroTeam memory heroTeam = _gameDB.getHeroTeam(heroTeamId);
            require(heroTeam.rank == gameTask.rank, "rank not match");
            _pMAI3Token.transferFrom(msg.sender, address(this), gameTask.gameFee);

            GameLib.HeroMeta memory heroMeta;
            bool isRarityExist;
            for (uint i = 0; i < heroTeam.tokenIds.length; i++) {
                heroMeta = _gameDB.getHeroMeta(heroTeam.tokenIds[i]);
                isRarityExist = false;
                for (uint256 j = 0; j < gameTask.rarities.length; j++) {
                    if (gameTask.rarities[j] == heroMeta.rarity) {
                        isRarityExist = true;
                        break;
                    }
                }
                require(isRarityExist, "rarity not match");
            }

            _gameFightCounts[gameTaskId][heroTeamId] = fightCount + 1;
            if (gameTask.endTime > _gameDB.getHeroTeamProtectionTime(heroTeamId)) {
                // If greater, modify
                _gameDB.setHeroTeamProtectionTime(heroTeamId, gameTask.endTime);
            }

            mapId = gameTask.mapId;
        }

        _fightNo++;
        FightRecord storage fightRecord = _fightRecords[_fightNo];
        fightRecord.owner = msg.sender;
        fightRecord.gameTaskId = gameTaskId;
        fightRecord.fightNo = _fightNo;
        fightRecord.mapId = mapId;
        fightRecord.heroTeamId = heroTeamId;
        _lastFightNo[msg.sender] = _fightNo;

        emit Fight(msg.sender, gameTaskId, _fightNo, mapId, heroTeamId);
    }

    // Claim rewards function
    function claimRewards(
        uint256 fightNo,
        uint256 exp,
        uint256[] calldata rewardIds,
        uint256[] calldata rewardNums,
        bytes calldata signature
    ) public nonReentrant {
        address owner = msg.sender;
        FightRecord storage record = _fightRecords[fightNo];
        require(!record.claimed, "rewards has already claimed");
        require(_gameDB.existsHeroTeam(msg.sender, record.heroTeamId), "Team id does not belong to you");
        require(rewardIds.length == rewardNums.length, "rewardIds, rewardNums array length must equals");
        require(_verifyClaimRewards(fightNo, owner, exp, rewardIds, rewardNums, signature), "verifyClaimRewards error");

        // Award dropping (items)
        for (uint256 i = 0; i < rewardIds.length; i++) {
            _backpackFactory.addBalance(rewardIds[i], owner, rewardNums[i]);
        }

        // Distribution of hero team experience
        if (exp > 0) {
            GameLib.HeroTeam memory heroTeam = _gameDB.getHeroTeam(record.heroTeamId);
            for (uint i = 0; i < heroTeam.tokenIds.length; i++) {
                GameLib.HeroMeta memory meta = _gameDB.getHeroMeta(heroTeam.tokenIds[i]);
                meta.experience += exp / 3;
                _gameDB.setHeroMeta(meta);
            }
            record.experiences = exp;
        }

        // 20% transferred to share pool, 2% transferred to treasury
        if (record.gameTaskId > 0 && !_claimedTeamFee[record.gameTaskId]) {
            GameTask memory gameTask = _gameTasks[record.gameTaskId];
            uint256 feeAmount = gameTask.totalFee * 2 / 100;
            uint256 sharePoolAmount = gameTask.totalFee * 20 / 100;

            _feeAccount.transferToFeeTreasury(feeAmount);
            _feeAccount.addRewardsToSharePool(sharePoolAmount);
            _claimedTeamFee[record.gameTaskId] = true;
        }

        record.claimed = true;

        emit ClaimRewards(msg.sender, record.gameTaskId, record.fightNo, record.mapId, record.heroTeamId);
    }

    // Claim rank rewards function
    function claimRankRewards(
        uint256[] calldata fightNos,
        uint256 exp,
        uint256 tokenAmount,
        uint256[] calldata rewardIds,
        uint256[] calldata rewardNums,
        bytes calldata signature
    ) public nonReentrant {
        address owner = msg.sender;
        require(rewardIds.length == rewardNums.length, "rewardIds, rewardNums array length must equals");
        require(_verifyClaimRankRewards(owner, fightNos, exp, tokenAmount, rewardIds, rewardNums, signature), "verifyRankClaimRewards error");

        uint256 heroTeamId;
        uint256 gameTaskId;
        uint256 mapId;
        for (uint i = 0; i < fightNos.length; i++) {
            uint256 recordId = fightNos[i];
            FightRecord storage record = _fightRecords[recordId];
            // Combat records must be the same team and mission
            if(i == 0) {
                require(!record.claimed, "rewards has already claimed");
                require(_gameDB.existsHeroTeam(msg.sender, record.heroTeamId), "Team id does not belong to you");

                GameTask memory task = getGameTask(record.gameTaskId);
                require(task.id > 0, "Game task does not exist");
                require(block.timestamp >= task.endTime, "Game task not end");

                heroTeamId = record.heroTeamId;
                gameTaskId = record.gameTaskId;
                mapId = record.mapId;
            } else {
                require(record.heroTeamId == heroTeamId, "heroTeamId different");
                require(record.gameTaskId == gameTaskId, "gameTaskId different");
            }

            record.claimed = true;
        }


        // Award dropping (items)
        for (uint256 i = 0; i < rewardIds.length; i++) {
            _backpackFactory.addBalance(rewardIds[i], owner, rewardNums[i]);
        }

        // Distribution of hero team experience
        if (exp > 0) {
            GameLib.HeroTeam memory heroTeam = _gameDB.getHeroTeam(heroTeamId);
            for (uint i = 0; i < heroTeam.tokenIds.length; i++) {
                GameLib.HeroMeta memory meta = _gameDB.getHeroMeta(heroTeam.tokenIds[i]);
                meta.experience += exp / 3;
                _gameDB.setHeroMeta(meta);
            }
        }

        if (tokenAmount > 0) {
            _feeAccount.transfer(owner, tokenAmount);
        }

        // 20% transferred to share pool, 2% transferred to treasury
        if (gameTaskId > 0 && !_claimedTeamFee[gameTaskId]) {
            GameTask memory gameTask = _gameTasks[gameTaskId];
            uint256 feeAmount = gameTask.totalFee * 2 / 100;
            uint256 sharePoolAmount = gameTask.totalFee * 20 / 100;

            _feeAccount.transferToFeeTreasury(feeAmount);
            _feeAccount.addRewardsToSharePool(sharePoolAmount);
            _claimedTeamFee[gameTaskId] = true;
        }

        emit ClaimRankRewards(msg.sender, gameTaskId, mapId, heroTeamId);
    }

    // Claim airdrop rewards function
    function claimAirdropRewards(uint256 nonce, uint256 tokenAmount, uint256 point, bytes calldata signature) public nonReentrant {
        require(!_nonces[nonce], "nonce have been used");
        require(_verifyClaimAirdropRewards(msg.sender, nonce, tokenAmount, point, signature), "verifyAirdropClaimRewards error");

        _nonces[nonce] = true;
        _feeAccount.transfer(msg.sender, tokenAmount);

        emit ClaimAirdropRewards(msg.sender, nonce, tokenAmount, point);
    }

    // Verify claim rewards function
    function _verifyClaimRewards(
        uint256 fightNo,
        address owner,
        uint256 exp,
        uint256[] calldata rewardIds,
        uint256[] calldata rewardNums,
        bytes memory signature
    ) private view returns (bool) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("ParamData(uint256 fightNo,address owner,uint256 exp,uint256[] rewardIds,uint256[] rewardNums)"),
            fightNo,
            owner,
            exp,
            keccak256(abi.encodePacked(rewardIds)),
            keccak256(abi.encodePacked(rewardNums))
        )));

        return SignatureCheckerUpgradeable.isValidSignatureNow(_signer, digest, signature);
    }

    // Verify claim rank rewards function
    function _verifyClaimRankRewards(
        address owner,
        uint256[] calldata fightNos,
        uint256 exp,
        uint256 tokenAmount,
        uint256[] calldata rewardIds,
        uint256[] calldata rewardNums,
        bytes calldata signature
    ) private view returns (bool) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("ParamData(address owner,uint256[] fightNos,uint256 exp,uint256 tokenAmount,uint256[] rewardIds,uint256[] rewardNums)"),
            owner,
            keccak256(abi.encodePacked(fightNos)),
            exp,
            tokenAmount,
            keccak256(abi.encodePacked(rewardIds)),
            keccak256(abi.encodePacked(rewardNums))
        )));

        return SignatureCheckerUpgradeable.isValidSignatureNow(_signer, digest, signature);
    }

    // Verify claim airdrop rewards function
    function _verifyClaimAirdropRewards(
        address owner,
        uint256 nonce,
        uint256 tokenAmount,
        uint256 point,
        bytes calldata signature
    ) private view returns (bool) {
        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
            keccak256("ParamData(address owner,uint256 nonce,uint256 tokenAmount,uint256 point)"),
            owner,
            nonce,
            tokenAmount,
            point
        )));

        return SignatureCheckerUpgradeable.isValidSignatureNow(_signer, digest, signature);
    }
    
    // Get last fight number function
    function getLastFightNo(address owner) public view returns (uint256 lastFightNo) {
        lastFightNo = _lastFightNo[owner];
    }

    // Get fight records by page function
    function getFightRecordsByPage(uint256 fightNo, uint256 pageSize) public view returns (FightRecord[] memory fightRecords) {
        fightRecords = new FightRecord[](pageSize);
        for (uint256 i = 0; i < pageSize; i++) {
            if (i + fightNo > _fightNo) break;
            fightRecords[i] = _fightRecords[i + fightNo];
        }
    }

    // Get game tasks by page function
    function getGameTasksByPage(uint256 gameTaskId, uint256 pageSize) public view returns (GameTask[] memory gameTasks) {
        gameTasks = new GameTask[](pageSize);
        for (uint256 i = 0; i < pageSize; i++) {
            if (i + gameTaskId > _gameTaskId) break;
            gameTasks[i] = _gameTasks[i + gameTaskId];
        }
    }

    // Get game task function
    function getGameTask(uint256 gameTaskId) public view returns (GameTask memory) {
        return _gameTasks[gameTaskId];
    }

    // Get fight record function
    function getFightRecord(uint256 fightNo) public view returns (FightRecord memory) {
        return _fightRecords[fightNo];
    }

    // Get all game members function
    function getGameMembers(uint256 gameTaskId) public view returns (uint256[] memory) {
        return _gameMembers[gameTaskId].values();
    }

    // Get game member number function
    function getGameMemberNum(uint256 gameTaskId) public view returns (uint256) {
        return _gameTasks[gameTaskId].joinPlayerNum;
    }

    // Check if team is joined function
    function isJoin(uint256 gameTaskId, uint256 heroTeamId) public view returns (bool) {
        return _gameMembers[gameTaskId].contains(heroTeamId);
    }

    // Get maximum fight number function
    function getMaxFightNo() public view returns (uint256) {
        return _fightNo;
    }

    // Get maximum game task ID function
    function getMaxGameTaskId() public view returns (uint256) {
        return _gameTaskId;
    }

    // Set signer function
    function setSigner(address signer) external onlyCaller {
        _signer = signer;
    }

    // Get game fight counts function
    function getGameFightCounts(uint256 heroTeamId, uint256 gameTaskId) public view returns (uint256) {
        return _gameFightCounts[heroTeamId][gameTaskId];
    }
}