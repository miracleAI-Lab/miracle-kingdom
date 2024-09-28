// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

library ConstLib {
    // coin
    uint8 public constant GOLD_COIN = 1;   // Gold Coin
    uint8 public constant USDT_COIN = 2;  // USDT
    uint8 public constant CORE_TOKEN = 3; // Governance Token

    // Ores
    uint8 public constant GOLD_ORE = 4;  // Gold Ore
    uint8 public constant SILVER_ORE = 5; // Silver Ore
    uint8 public constant COPPER_ORE = 6;  // Copper Ore
    uint8 public constant BLACK_IRON_STONE = 7; // Black Iron Stone
    uint8 public constant GOLD_SILVE_STONE = 8; // Mithril Ore

    // Gems
    uint8 public constant RED_GEM_STONE = 9;  // Ruby
    uint8 public constant BLUE_GEM_STONE = 10; // Sapphire
    uint8 public constant YELLOW_GEM_STONE = 11; // Topaz
    uint8 public constant ENERGY_STONE = 12; // Energy Stone
    uint8 public constant LUCKY_STONE = 13; // Lucky Stone
    uint8 public constant CRYSTAL = 14; // Crystal
    uint8 public constant DIAMOND = 15; // Diamond

    // Points
    uint8 public constant BRAVE_POINTS = 16; // Brave Points
    uint8 public constant HONOR_VALUE = 17; // Honor Value

    // Lucky Potion
    uint8 public constant LUCKY_POTION = 18; 

    // Hides
    uint8 public constant HIDE_LOW = 19;  // Ordinary Hide
    uint8 public constant HIDE_MIDDLE = 20;  // Tough Hide
    uint8 public constant HIDE_HIGH = 21;  // Enchanted Hide
    uint8 public constant HIDE_SUPER = 22;  // Divine Hide
    uint8 public constant HIDE_SUPER_SUPER = 23; // Rainbow Dragon Scale

    // Bushmeat
    uint8 public constant BUSHMEAT_LOW = 24;  // Inferior Bushmeat
    uint8 public constant BUSHMEAT_MIDDLE = 25;  // Ordinary Bushmeat
    uint8 public constant BUSHMEAT_HIGH = 26;  // Premium Bushmeat

    // Cloth
    uint8 public constant CLOTH_LOW = 27;  // Coarse Cloth
    uint8 public constant CLOTH_MIDDLE = 28;  // Fine Cloth
    uint8 public constant CLOTH_HIGH = 29;  // Silk
    uint8 public constant CLOTH_SUPER = 30;  // Satin
    uint8 public constant CLOTH_SUPER_SUPER = 31;  // Divine Silk
    
    // Wood
    uint8 public constant WOOD_LOW = 32;  // Poplar Wood
    uint8 public constant WOOD_MIDDLE = 33;  // Cypress Wood
    uint8 public constant WOOD_HIGH = 34;  // Oak Wood
    uint8 public constant WOOD_SUPER = 35;  // Thunder Wood
    uint8 public constant WOOD_SUPER_SUPER = 36;  // Phoenix Wood

    // Fragments
    uint8 public constant RULE_FRAGMENTS = 37;  // Rule Fragments
    uint8 public constant SOUL_FRAGMENTS = 38;  // Soul Fragments
    uint8 public constant DIVINE_FRAGMENTS = 39;  // Divine Fragments

    // Rarity
    uint8 public constant RARITY_NORMAL = 1;             // N
    uint8 public constant RARITY_RARE = 2;               // R
    uint8 public constant RARITY_SUPER_RARE = 3;          // SR
    uint8 public constant RARITY_SUPERIOR_SUPER_RARE = 4; // SSR
    uint8 public constant RARITY_ULTRA_RARE = 5;          // UR

    // Career
    uint8 public constant WARRIOR = 1; // WARRIOR
    uint8 public constant MAGE = 2;  // MAGE
    uint8 public constant ASSASSIN = 3;  // Assassin
    uint8 public constant KNIGHT = 4;   // Knight
    uint8 public constant PRIEST = 5;   // Priest
    uint8 public constant WARLOCK = 6;   // Warlock

    uint8 public constant PROP_TYPE_COIN = 1; // Coin
    uint8 public constant PROP_TYPE_STONE = 2; // Ore
    uint8 public constant PROP_TYPE_GEM_STONE = 3; // Gem
    uint8 public constant PROP_TYPE_SCORE = 4; // Points
    uint8 public constant PROP_TYPE_POTION = 5; // Potion
    uint8 public constant PROP_TYPE_HIDE = 6; // Hide
    uint8 public constant PROP_TYPE_BUSHMEAT = 7; // Bushmeat
    uint8 public constant PROP_TYPE_CLOTH = 8; // Cloth
    uint8 public constant PROP_TYPE_WOOD = 9; // Wood
    uint8 public constant PROP_TYPE_FRAGMENTS = 10; // Fragments

    uint8 public constant WEAPON = 1; // Weapon
    uint8 public constant ARMOR = 2;  // Armor

    uint256 public constant SECONDS_PER_DAY = 28800; // 每天区块数
}