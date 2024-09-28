// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

library GameLib {
    bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
    bytes32 public constant CALLER_ROLE = keccak256("CALLER_ROLE");
    bytes32 public constant GENERATER_ROLE = keccak256("GENERATER_ROLE");

    // NFT attributes
    struct HeroMeta {
        uint256 tokenId; 
        uint256 career; // Career
        uint256 gender; // Gender
        uint256 skinId; // Skin ID
        uint256 strength; // Strength
        uint256 attack; // Attack
        uint256 spirit; // Spirit
        uint256 agile; // Agile
        uint256 defense; // Defense
        uint256 hitPoint;  // Hit points
        uint256 power;   // Power
        uint256 rarity;  // Rarity
        uint256 level;   // Level
        uint256 experience; // Experience
        uint256 honor;      // Honor
        uint256 rank;       // Rank
        uint256 star;       // Stars
        uint256 age;        // Age
        uint256 joinTime;   // Join time
        string image;       // Image URL
    }

    /*** typeId: Prop type
     *** 1: Gold Coin, 2: Metal Coin, 3: USDT, 4: Governance Token, 5: Gem, 6: Points, 7: Potion
     *** 8: Skill Book, 9: Beast Meat and Fur, 10: Fabric
    ****/
    struct Prop {
        string name; // Name
        uint256 id; // ID
        uint256 typeId; // Prop type
        uint256 startId; // Start ID
        uint256 endId;   // End ID
        uint256 minLevel; // Minimum level requirement
        uint256 value; // Additional property value of the item
        uint256 valueType; // Type of additional property value of the item: 1 damage, 2 defense, 3 group attack, 4 dodge damage, 5 health recovery, 6 health recovery + dispel negative effects, 7 revive teammate, 8 passive skill recover health for teammates every round, 9 absorb health, 10 all opponents are paralyzed this round, 11 health drops to threshold trigger recovery
        uint256 triggerValue; // Trigger threshold
        uint256 unit; // Value depends on unit, 1 is numeric, 2 is percentage
        uint256 effectRange; // Effect range, 1 single target, 2 group
    }

    // Skill template
    struct Skill {
        string name; // Name
        uint256 id; // ID
        uint256 maxLevel; // Maximum level that the skill can be upgraded to
        uint256 career; // Hero's career
        uint256 valueType; // Type of additional property value of the item: 1 damage, 2 defense, 3 blood loss, 4 evasion, 5 health recovery, 6 health recovery + dispel negative effects, 7 revive teammate, 8 passive skill recover health for teammates every round, 9 absorb health, 10 all opponents are paralyzed this round, 11 health drops to threshold trigger recovery, 12 damage reduction
        uint256 triggerValue; // Trigger threshold
        uint256 unit; // Value depends on unit, 1 is numeric, 2 is percentage
        uint256 effectRange; // Effect range, 1 single target, 2 group
        uint256 effectDistance; // Effect distance, 1 melee, 2 ranged
        uint256 limit; // Number of times allowed to cast
        uint256 round; // Duration in rounds
        uint256 calculationType; // Calculation type, 1 true damage/defense, 2 physical damage/defense, 3 magical damage/defense
        uint256[] heroReqLevels; // Required hero levels
        uint256[] fees; // Gold coins consumed at each level
        uint256[] values; // Values at different levels
    }

    // Learned skills
    struct LearnSkill {
        uint256 skillId;
        uint256 level;
    }

    // Hero team
    struct HeroTeam {
        address owner;
        string name;
        uint256 id;
        uint256 rank;
        uint256[] tokenIds;
    }

    /*** typeId: Equipment type
     *** 1: Gold Coin, 2: Metal Coin, 3: USDT, 4: Governance Token, 5: Gem, 6: Points, 7: Potion
     *** 8: Skill Book, 9: Beast Meat and Fur, 10: Fabric
    ****/
    struct Equipment {
        string name;
        uint256 id;     // equip id
        uint256 typeId; // Weapon type
        uint256 minLevel; // Level requirement
        uint256 valueType; // Attribute type
        uint256 inlayNum; // Number of sockets
        uint256 quality; // Weapon quality
        uint256 durable; // Equipment durability
        uint256 unit; // Value depends on unit, 1 is numeric, 2 is percentage
        uint256 star; // Star level
        uint256 fee; // Gold coin cost
        uint256[] careers; // Career restrictions
        uint256[] material; // Casting materials, propId
        uint256[] materialNum; // Number of casting materials
        uint256[] mainValues; // Main attribute values
    }

    struct EquipmentMeta {
        string name;
        uint256 equipId; // equip id
        uint256 tokenId; // nft tokenId
        uint256 typeId; // Weapon type
        uint256 minLevel; // Minimum level requirement
        uint256 valueType; // Attribute type
        uint256 inlayNum; // Number of sockets
        uint256 gemNum1; // Number of inlaid rubies
        uint256 gemNum2; // Number of inlaid sapphires
        uint256 gemNum3; // Number of inlaid emeralds
        uint256 addStrength; // +Strength
        uint256 addSpirit;   // +Spirit
        uint256 addAgile;    // +Agile
        uint256 quality;     // Weapon quality
        uint256 durable;     // Equipment initial durability
        uint256 cdurable;    // Current durability of equipment
        uint256 unit;        // Value depends on unit, 1 is numeric, 2 is percentage
        uint256 star; // Star rating
        string image; // Image URL
        uint256[] careers; // Career restrictions
        uint256[] mainValues; // Main attribute values
        uint256[] gemstones; // Array of gems.
    }

    // Upgrade
    struct UpgradeExperience {
         uint256 fee; // Upgrade cost (consumption of MIRA coins)
         uint256 experience; // Upgrade experience
    }

    function getRandxNum(
        uint256 _randomSeed,
        uint256 minNum,
        uint256 maxNum
    ) internal view returns (uint256) {
        uint256 _seed = uint256(
            keccak256(abi.encodePacked(_randomSeed, blockhash(block.number - 1), block.gaslimit, address(this), msg.sender, maxNum, block.timestamp, block.difficulty, minNum))
        );
        return (_seed % (maxNum - minNum + 1)) + minNum;
    }
}