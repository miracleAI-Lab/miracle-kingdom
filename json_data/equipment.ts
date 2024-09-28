// 装备模板数组
import { Career } from "./hero";
import { Prop } from "./prop";

// 装备类型
enum TypeId {
    WEAPON = 1, // 武器
    ARMOR, //护甲
}

// 武器品质
enum Quality {
    IRON = 1, // 黑铁
    COPPER, // 青铜
    SILVER, // 白银
    GOLD, // 黄金
    KING, // 王者
}

enum ValueType {
    STRENGTH = 1, // 力量
    SPIRIT, // 精神
    AGILE, // 敏捷
}

// 武器品质
enum Rank {
    IRON = 1, // 黑铁
    COPPER, // 青铜
    SILVER, // 白银
    GOLD, // 黄金
    KING, // 王者
}

const EquipmentArray = [
    {
        "id": 1,
        "name": "Short Sword",
        "typeId": 1,
        "minLevel": 1,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            19
        ],
        "materialNum": [
            200,
            200
        ],
        "mainValues": [
            53,
            73
        ],
        "valueType": 1,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 2,
        "name": "Long Staff",
        "typeId": 1,
        "minLevel": 1,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            19
        ],
        "materialNum": [
            175,
            225
        ],
        "mainValues": [
            53,
            73
        ],
        "valueType": 1,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 3,
        "name": "Battle Axe",
        "typeId": 1,
        "minLevel": 6,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            6,
            20
        ],
        "materialNum": [
            50,
            175,
            200
        ],
        "mainValues": [
            119,
            139
        ],
        "valueType": 1,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 4,
        "name": "One-Handed Sword",
        "typeId": 1,
        "minLevel": 6,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            6,
            20
        ],
        "materialNum": [
            50,
            150,
            225
        ],
        "mainValues": [
            119,
            139
        ],
        "valueType": 1,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 5,
        "name": "Dual Bladed Axe",
        "typeId": 1,
        "minLevel": 11,
        "careers": [
            1,
            4
        ],
        "material": [
            6,
            5,
            21
        ],
        "materialNum": [
            50,
            175,
            200
        ],
        "mainValues": [
            175,
            195
        ],
        "valueType": 1,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 6,
        "name": "Two-Handed Sword",
        "typeId": 1,
        "minLevel": 11,
        "careers": [
            1,
            4
        ],
        "material": [
            6,
            5,
            21
        ],
        "materialNum": [
            50,
            150,
            225
        ],
        "mainValues": [
            175,
            195
        ],
        "valueType": 1,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 7,
        "name": "War Hammer",
        "typeId": 1,
        "minLevel": 16,
        "careers": [
            1,
            4
        ],
        "material": [
            5,
            4,
            22
        ],
        "materialNum": [
            50,
            175,
            200
        ],
        "mainValues": [
            230,
            250
        ],
        "valueType": 1,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 8,
        "name": "Great Sword",
        "typeId": 1,
        "minLevel": 16,
        "careers": [
            1,
            4
        ],
        "material": [
            5,
            4,
            22
        ],
        "materialNum": [
            50,
            150,
            225
        ],
        "mainValues": [
            230,
            250
        ],
        "valueType": 1,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 9,
        "name": "Sword of the King",
        "typeId": 1,
        "minLevel": 20,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            150,
            225,
            50,
            75
        ],
        "mainValues": [
            275,
            295
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 0,
        "fee": "12000000000000000000"
    },
    {
        "id": 10,
        "name": "Dagger",
        "typeId": 1,
        "minLevel": 1,
        "careers": [
            3
        ],
        "material": [
            7,
            32
        ],
        "materialNum": [
            125,
            275
        ],
        "mainValues": [
            72,
            92
        ],
        "valueType": 2,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 11,
        "name": "Sleeve Blade",
        "typeId": 1,
        "minLevel": 1,
        "careers": [
            3
        ],
        "material": [
            7,
            32
        ],
        "materialNum": [
            175,
            225
        ],
        "mainValues": [
            72,
            92
        ],
        "valueType": 2,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 12,
        "name": "Throwing Spear",
        "typeId": 1,
        "minLevel": 6,
        "careers": [
            3
        ],
        "material": [
            7,
            6,
            32,
            33
        ],
        "materialNum": [
            50,
            100,
            50,
            250
        ],
        "mainValues": [
            156,
            176
        ],
        "valueType": 2,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 13,
        "name": "Thrusting Sword",
        "typeId": 1,
        "minLevel": 6,
        "careers": [
            3
        ],
        "material": [
            7,
            6,
            32,
            33
        ],
        "materialNum": [
            50,
            150,
            50,
            200
        ],
        "mainValues": [
            156,
            176
        ],
        "valueType": 2,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 14,
        "name": "Crossbow",
        "typeId": 1,
        "minLevel": 11,
        "careers": [
            3
        ],
        "material": [
            6,
            5,
            33,
            34
        ],
        "materialNum": [
            50,
            100,
            50,
            250
        ],
        "mainValues": [
            226,
            246
        ],
        "valueType": 2,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 15,
        "name": "Katana",
        "typeId": 1,
        "minLevel": 11,
        "careers": [
            3
        ],
        "material": [
            6,
            5,
            33,
            34
        ],
        "materialNum": [
            50,
            150,
            50,
            200
        ],
        "mainValues": [
            226,
            246
        ],
        "valueType": 2,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 16,
        "name": "Dual Daggers",
        "typeId": 1,
        "minLevel": 16,
        "careers": [
            3
        ],
        "material": [
            5,
            4,
            34,
            35
        ],
        "materialNum": [
            50,
            100,
            50,
            250
        ],
        "mainValues": [
            296,
            316
        ],
        "valueType": 2,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 17,
        "name": "Moon Wheel",
        "typeId": 1,
        "minLevel": 16,
        "careers": [
            3
        ],
        "material": [
            5,
            4,
            34,
            35
        ],
        "materialNum": [
            50,
            150,
            50,
            200
        ],
        "mainValues": [
            296,
            316
        ],
        "valueType": 2,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 18,
        "name": "Shadow Blade",
        "typeId": 1,
        "minLevel": 20,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            50,
            225,
            150,
            75
        ],
        "mainValues": [
            352,
            372
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 0,
        "fee": "12000000000000000000"
    },
    {
        "id": 19,
        "name": "Short Staff",
        "typeId": 1,
        "minLevel": 1,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            32,
            27
        ],
        "materialNum": [
            50,
            225,
            125
        ],
        "mainValues": [
            65,
            85
        ],
        "valueType": 3,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 20,
        "name": "Magic Wand",
        "typeId": 1,
        "minLevel": 1,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            32,
            19
        ],
        "materialNum": [
            50,
            250,
            100
        ],
        "mainValues": [
            65,
            85
        ],
        "valueType": 3,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 21,
        "name": "Staff",
        "typeId": 1,
        "minLevel": 6,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            6,
            32,
            33,
            27,
            28
        ],
        "materialNum": [
            50,
            25,
            50,
            200,
            50,
            100
        ],
        "mainValues": [
            141,
            161
        ],
        "valueType": 3,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 22,
        "name": "Scepter",
        "typeId": 1,
        "minLevel": 6,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            6,
            32,
            33,
            19,
            20
        ],
        "materialNum": [
            50,
            25,
            50,
            225,
            50,
            75
        ],
        "mainValues": [
            141,
            161
        ],
        "valueType": 3,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 23,
        "name": "Crescent Moon Staff",
        "typeId": 1,
        "minLevel": 11,
        "careers": [
            2,
            6
        ],
        "material": [
            6,
            5,
            33,
            34,
            28,
            29
        ],
        "materialNum": [
            50,
            25,
            50,
            200,
            50,
            100
        ],
        "mainValues": [
            205,
            225
        ],
        "valueType": 3,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 24,
        "name": "Starshine Staff",
        "typeId": 1,
        "minLevel": 11,
        "careers": [
            2,
            6
        ],
        "material": [
            6,
            5,
            33,
            34,
            20,
            21
        ],
        "materialNum": [
            50,
            25,
            50,
            225,
            50,
            75
        ],
        "mainValues": [
            205,
            225
        ],
        "valueType": 3,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "0"
    },
    {
        "id": 25,
        "name": "Prayer Staff",
        "typeId": 1,
        "minLevel": 16,
        "careers": [
            2,
            6
        ],
        "material": [
            5,
            4,
            34,
            35,
            29,
            30
        ],
        "materialNum": [
            50,
            25,
            50,
            200,
            50,
            100
        ],
        "mainValues": [
            269,
            289
        ],
        "valueType": 3,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 26,
        "name": "Mage's Scepter",
        "typeId": 1,
        "minLevel": 16,
        "careers": [
            2,
            6
        ],
        "material": [
            5,
            4,
            34,
            35,
            21,
            22
        ],
        "materialNum": [
            50,
            25,
            50,
            225,
            50,
            75
        ],
        "mainValues": [
            269,
            289
        ],
        "valueType": 3,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 27,
        "name": "Staff of Truth",
        "typeId": 1,
        "minLevel": 20,
        "careers": [
            2,
            6
        ],
        "material": [
            8,
            35,
            36
        ],
        "materialNum": [
            100,
            200,
            200
        ],
        "mainValues": [
            321,
            341
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 0,
        "fee": "12000000000000000000"
    },
    {
        "id": 28,
        "name": "Gambeson",
        "typeId": 2,
        "minLevel": 1,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            19,
            27
        ],
        "materialNum": [
            50,
            125,
            225
        ],
        "mainValues": [
            7,
            17
        ],
        "valueType": 1,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 29,
        "name": "Leather Armor",
        "typeId": 2,
        "minLevel": 1,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            19,
            27
        ],
        "materialNum": [
            50,
            225,
            125
        ],
        "mainValues": [
            7,
            17
        ],
        "valueType": 1,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 30,
        "name": "Mail Armor",
        "typeId": 2,
        "minLevel": 6,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            6,
            19,
            20,
            27,
            28
        ],
        "materialNum": [
            50,
            25,
            50,
            100,
            50,
            200
        ],
        "mainValues": [
            21,
            31
        ],
        "valueType": 1,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 31,
        "name": "Plate Armor",
        "typeId": 2,
        "minLevel": 6,
        "careers": [
            1,
            4
        ],
        "material": [
            7,
            6,
            19,
            20,
            27,
            28
        ],
        "materialNum": [
            50,
            25,
            50,
            200,
            50,
            100
        ],
        "mainValues": [
            21,
            31
        ],
        "valueType": 1,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 32,
        "name": "Scale Armor",
        "typeId": 2,
        "minLevel": 11,
        "careers": [
            1,
            4
        ],
        "material": [
            6,
            5,
            20,
            21,
            28,
            29
        ],
        "materialNum": [
            50,
            25,
            50,
            100,
            50,
            200
        ],
        "mainValues": [
            34,
            44
        ],
        "valueType": 1,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 33,
        "name": "Plate Mail",
        "typeId": 2,
        "minLevel": 11,
        "careers": [
            1,
            4
        ],
        "material": [
            6,
            5,
            20,
            21,
            28,
            29
        ],
        "materialNum": [
            50,
            25,
            50,
            200,
            50,
            100
        ],
        "mainValues": [
            34,
            44
        ],
        "valueType": 1,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 34,
        "name": "Dragon Slayer Armor",
        "typeId": 2,
        "minLevel": 16,
        "careers": [
            1,
            4
        ],
        "material": [
            5,
            4,
            21,
            22,
            29,
            30
        ],
        "materialNum": [
            50,
            25,
            50,
            100,
            50,
            200
        ],
        "mainValues": [
            46,
            56
        ],
        "valueType": 1,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 35,
        "name": "Victory Gear",
        "typeId": 2,
        "minLevel": 16,
        "careers": [
            1,
            4
        ],
        "material": [
            5,
            4,
            21,
            22,
            29,
            30
        ],
        "materialNum": [
            50,
            25,
            50,
            200,
            50,
            100
        ],
        "mainValues": [
            46,
            56
        ],
        "valueType": 1,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 36,
        "name": "War God's Gear",
        "typeId": 2,
        "minLevel": 20,
        "careers": [
            1,
            4
        ],
        "material": [
            8,
            22,
            23,
            30
        ],
        "materialNum": [
            100,
            50,
            200,
            150
        ],
        "mainValues": [
            56,
            66
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 0,
        "fee": "12000000000000000000"
    },
    {
        "id": 37,
        "name": "Rough Cloth Cape",
        "typeId": 2,
        "minLevel": 1,
        "careers": [
            3
        ],
        "material": [
            7,
            27
        ],
        "materialNum": [
            150,
            250
        ],
        "mainValues": [
            20,
            30
        ],
        "valueType": 2,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 38,
        "name": "Rough Cloth Set",
        "typeId": 2,
        "minLevel": 1,
        "careers": [
            3
        ],
        "material": [
            7,
            19
        ],
        "materialNum": [
            75,
            325
        ],
        "mainValues": [
            20,
            30
        ],
        "valueType": 2,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 39,
        "name": "Assassin's Robe",
        "typeId": 2,
        "minLevel": 6,
        "careers": [
            3
        ],
        "material": [
            7,
            6,
            27,
            28
        ],
        "materialNum": [
            50,
            125,
            50,
            225
        ],
        "mainValues": [
            47,
            57
        ],
        "valueType": 2,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 40,
        "name": "Shadow Guard Robe",
        "typeId": 2,
        "minLevel": 6,
        "careers": [
            3
        ],
        "material": [
            7,
            6,
            19,
            20
        ],
        "materialNum": [
            50,
            50,
            50,
            300
        ],
        "mainValues": [
            47,
            57
        ],
        "valueType": 2,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 41,
        "name": "Dark Night Set",
        "typeId": 2,
        "minLevel": 11,
        "careers": [
            3
        ],
        "material": [
            6,
            5,
            28,
            29
        ],
        "materialNum": [
            50,
            125,
            50,
            225
        ],
        "mainValues": [
            70,
            80
        ],
        "valueType": 2,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 42,
        "name": "Phantom Set",
        "typeId": 2,
        "minLevel": 11,
        "careers": [
            3
        ],
        "material": [
            6,
            5,
            20,
            21
        ],
        "materialNum": [
            50,
            50,
            50,
            300
        ],
        "mainValues": [
            70,
            80
        ],
        "valueType": 2,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 43,
        "name": "Dark Gold Armor",
        "typeId": 2,
        "minLevel": 16,
        "careers": [
            3
        ],
        "material": [
            5,
            4,
            29,
            30
        ],
        "materialNum": [
            50,
            125,
            50,
            225
        ],
        "mainValues": [
            93,
            103
        ],
        "valueType": 2,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 44,
        "name": "Slaughter Gear",
        "typeId": 2,
        "minLevel": 16,
        "careers": [
            3
        ],
        "material": [
            5,
            4,
            21,
            22
        ],
        "materialNum": [
            50,
            50,
            50,
            300
        ],
        "mainValues": [
            93,
            103
        ],
        "valueType": 2,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 45,
        "name": "Death God's Gear",
        "typeId": 2,
        "minLevel": 20,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            22,
            23,
            31
        ],
        "materialNum": [
            150,
            150,
            50,
            50,
            100
        ],
        "mainValues": [
            111,
            121
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 0,
        "fee": "12000000000000000000"
    },
    {
        "id": 46,
        "name": "Apprentice Robe",
        "typeId": 2,
        "minLevel": 1,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            32,
            27
        ],
        "materialNum": [
            50,
            100,
            250
        ],
        "mainValues": [
            19,
            29
        ],
        "valueType": 3,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 47,
        "name": "Apostle Robe",
        "typeId": 2,
        "minLevel": 1,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            32,
            27
        ],
        "materialNum": [
            50,
            125,
            225
        ],
        "mainValues": [
            19,
            29
        ],
        "valueType": 3,
        "inlayNum": 2,
        "quality": 1,
        "durable": 10,
        "unit": 1,
        "star": 0,
        "fee": "2000000000000000000"
    },
    {
        "id": 48,
        "name": "Crimson Robe",
        "typeId": 2,
        "minLevel": 6,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            6,
            32,
            33,
            27,
            28
        ],
        "materialNum": [
            50,
            25,
            50,
            75,
            50,
            225
        ],
        "mainValues": [
            44,
            54
        ],
        "valueType": 3,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 49,
        "name": "Soul Robe",
        "typeId": 2,
        "minLevel": 6,
        "careers": [
            2,
            6
        ],
        "material": [
            7,
            6,
            32,
            33,
            27,
            28
        ],
        "materialNum": [
            50,
            25,
            50,
            100,
            50,
            200
        ],
        "mainValues": [
            44,
            54
        ],
        "valueType": 3,
        "inlayNum": 4,
        "quality": 2,
        "durable": 20,
        "unit": 1,
        "star": 0,
        "fee": "5000000000000000000"
    },
    {
        "id": 50,
        "name": "Mage's Robe",
        "typeId": 2,
        "minLevel": 11,
        "careers": [
            2,
            6
        ],
        "material": [
            6,
            5,
            33,
            34,
            28,
            29
        ],
        "materialNum": [
            50,
            25,
            50,
            75,
            50,
            225
        ],
        "mainValues": [
            66,
            76
        ],
        "valueType": 3,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 51,
        "name": "Demon Robe",
        "typeId": 2,
        "minLevel": 11,
        "careers": [
            2,
            6
        ],
        "material": [
            6,
            5,
            33,
            34,
            28,
            29
        ],
        "materialNum": [
            50,
            25,
            50,
            100,
            50,
            200
        ],
        "mainValues": [
            66,
            76
        ],
        "valueType": 3,
        "inlayNum": 6,
        "quality": 3,
        "durable": 30,
        "unit": 1,
        "star": 0,
        "fee": "7000000000000000000"
    },
    {
        "id": 52,
        "name": "Archmage Robe",
        "typeId": 2,
        "minLevel": 16,
        "careers": [
            2,
            6
        ],
        "material": [
            5,
            4,
            34,
            35,
            29,
            30
        ],
        "materialNum": [
            50,
            25,
            50,
            75,
            50,
            225
        ],
        "mainValues": [
            87,
            97
        ],
        "valueType": 3,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 53,
        "name": "Demigod Gear",
        "typeId": 2,
        "minLevel": 16,
        "careers": [
            2,
            6
        ],
        "material": [
            5,
            4,
            34,
            35,
            29,
            30
        ],
        "materialNum": [
            50,
            25,
            50,
            100,
            50,
            200
        ],
        "mainValues": [
            87,
            97
        ],
        "valueType": 3,
        "inlayNum": 8,
        "quality": 4,
        "durable": 40,
        "unit": 1,
        "star": 0,
        "fee": "10000000000000000000"
    },
    {
        "id": 54,
        "name": "Truth's Gear",
        "typeId": 2,
        "minLevel": 20,
        "careers": [
            2,
            6
        ],
        "material": [
            4,
            8,
            30,
            31
        ],
        "materialNum": [
            150,
            200,
            50,
            100
        ],
        "mainValues": [
            104,
            114
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 0,
        "fee": "12000000000000000000"
    },
    {
        "id": 55,
        "name": "",
        "typeId": 1,
        "minLevel": 22,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            175,
            225,
            150,
            150
        ],
        "mainValues": [
            296,
            316
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 1,
        "fee": "13000000000000000000"
    },
    {
        "id": 56,
        "name": "",
        "typeId": 1,
        "minLevel": 22,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            100,
            225,
            225,
            150
        ],
        "mainValues": [
            379,
            399
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 1,
        "fee": "13000000000000000000"
    },
    {
        "id": 57,
        "name": "",
        "typeId": 1,
        "minLevel": 22,
        "careers": [
            2,
            6
        ],
        "material": [
            8,
            35,
            36
        ],
        "materialNum": [
            125,
            325,
            250
        ],
        "mainValues": [
            346,
            366
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 1,
        "fee": "13000000000000000000"
    },
    {
        "id": 58,
        "name": "",
        "typeId": 2,
        "minLevel": 22,
        "careers": [
            1,
            4
        ],
        "material": [
            8,
            22,
            23,
            30
        ],
        "materialNum": [
            125,
            125,
            250,
            200
        ],
        "mainValues": [
            61,
            71
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 1,
        "fee": "13000000000000000000"
    },
    {
        "id": 59,
        "name": "",
        "typeId": 2,
        "minLevel": 22,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            22,
            23,
            31
        ],
        "materialNum": [
            175,
            150,
            150,
            75,
            150
        ],
        "mainValues": [
            120,
            130
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 1,
        "fee": "13000000000000000000"
    },
    {
        "id": 60,
        "name": "",
        "typeId": 2,
        "minLevel": 22,
        "careers": [
            2,
            6
        ],
        "material": [
            4,
            8,
            30,
            31
        ],
        "materialNum": [
            200,
            225,
            125,
            150
        ],
        "mainValues": [
            113,
            123
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 1,
        "fee": "13000000000000000000"
    },
    {
        "id": 61,
        "name": "",
        "typeId": 1,
        "minLevel": 24,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            200,
            200,
            250,
            250
        ],
        "mainValues": [
            317,
            337
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 2,
        "fee": "14000000000000000000"
    },
    {
        "id": 62,
        "name": "",
        "typeId": 1,
        "minLevel": 24,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            175,
            175,
            275,
            275
        ],
        "mainValues": [
            406,
            426
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 2,
        "fee": "14000000000000000000"
    },
    {
        "id": 63,
        "name": "",
        "typeId": 1,
        "minLevel": 24,
        "careers": [
            2,
            6
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            125,
            225,
            325,
            225
        ],
        "mainValues": [
            371,
            391
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 2,
        "fee": "14000000000000000000"
    },
    {
        "id": 64,
        "name": "",
        "typeId": 2,
        "minLevel": 24,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            22,
            23,
            30
        ],
        "materialNum": [
            100,
            175,
            175,
            275,
            175
        ],
        "mainValues": [
            66,
            76
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 2,
        "fee": "14000000000000000000"
    },
    {
        "id": 65,
        "name": "",
        "typeId": 2,
        "minLevel": 24,
        "careers": [
            3
        ],
        "material": [
            8,
            22,
            23,
            31
        ],
        "materialNum": [
            175,
            450,
            150,
            125
        ],
        "mainValues": [
            129,
            139
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 2,
        "fee": "14000000000000000000"
    },
    {
        "id": 66,
        "name": "",
        "typeId": 2,
        "minLevel": 24,
        "careers": [
            2,
            6
        ],
        "material": [
            8,
            30,
            31
        ],
        "materialNum": [
            200,
            450,
            250
        ],
        "mainValues": [
            121,
            131
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 2,
        "fee": "14000000000000000000"
    },
    {
        "id": 67,
        "name": "",
        "typeId": 1,
        "minLevel": 26,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            275,
            225,
            275,
            300
        ],
        "mainValues": [
            339,
            359
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 3,
        "fee": "15000000000000000000"
    },
    {
        "id": 68,
        "name": "",
        "typeId": 1,
        "minLevel": 26,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            225,
            200,
            325,
            325
        ],
        "mainValues": [
            433,
            453
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 3,
        "fee": "15000000000000000000"
    },
    {
        "id": 69,
        "name": "",
        "typeId": 1,
        "minLevel": 26,
        "careers": [
            2,
            6
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            275,
            250,
            275,
            275
        ],
        "mainValues": [
            395,
            415
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 3,
        "fee": "15000000000000000000"
    },
    {
        "id": 70,
        "name": "",
        "typeId": 2,
        "minLevel": 26,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            22,
            23,
            30
        ],
        "materialNum": [
            175,
            200,
            175,
            325,
            200
        ],
        "mainValues": [
            71,
            81
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 3,
        "fee": "15000000000000000000"
    },
    {
        "id": 71,
        "name": "",
        "typeId": 2,
        "minLevel": 26,
        "careers": [
            3
        ],
        "material": [
            8,
            22,
            23,
            31
        ],
        "materialNum": [
            200,
            550,
            175,
            150
        ],
        "mainValues": [
            138,
            148
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 3,
        "fee": "15000000000000000000"
    },
    {
        "id": 72,
        "name": "",
        "typeId": 2,
        "minLevel": 26,
        "careers": [
            2,
            6
        ],
        "material": [
            8,
            30,
            31
        ],
        "materialNum": [
            225,
            550,
            300
        ],
        "mainValues": [
            130,
            140
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 3,
        "fee": "15000000000000000000"
    },
    {
        "id": 73,
        "name": "",
        "typeId": 1,
        "minLevel": 28,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            325,
            300,
            425,
            525
        ],
        "mainValues": [
            360,
            380
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 4,
        "fee": "16000000000000000000"
    },
    {
        "id": 74,
        "name": "",
        "typeId": 1,
        "minLevel": 28,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            300,
            200,
            450,
            625
        ],
        "mainValues": [
            460,
            480
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 4,
        "fee": "16000000000000000000"
    },
    {
        "id": 75,
        "name": "",
        "typeId": 1,
        "minLevel": 28,
        "careers": [
            2,
            6
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            225,
            250,
            525,
            575
        ],
        "mainValues": [
            420,
            440
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 4,
        "fee": "16000000000000000000"
    },
    {
        "id": 76,
        "name": "",
        "typeId": 2,
        "minLevel": 28,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            22,
            23,
            30
        ],
        "materialNum": [
            250,
            200,
            225,
            625,
            275
        ],
        "mainValues": [
            76,
            86
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 4,
        "fee": "16000000000000000000"
    },
    {
        "id": 77,
        "name": "",
        "typeId": 2,
        "minLevel": 28,
        "careers": [
            3
        ],
        "material": [
            8,
            22,
            23,
            31
        ],
        "materialNum": [
            225,
            750,
            325,
            275
        ],
        "mainValues": [
            147,
            157
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 4,
        "fee": "16000000000000000000"
    },
    {
        "id": 78,
        "name": "",
        "typeId": 2,
        "minLevel": 28,
        "careers": [
            2,
            6
        ],
        "material": [
            8,
            30,
            31
        ],
        "materialNum": [
            275,
            750,
            550
        ],
        "mainValues": [
            139,
            149
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 4,
        "fee": "16000000000000000000"
    },
    {
        "id": 79,
        "name": "",
        "typeId": 1,
        "minLevel": 30,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            375,
            325,
            575,
            800
        ],
        "mainValues": [
            381,
            401
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 5,
        "fee": "17000000000000000000"
    },
    {
        "id": 80,
        "name": "",
        "typeId": 1,
        "minLevel": 30,
        "careers": [
            3
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            325,
            225,
            625,
            900
        ],
        "mainValues": [
            487,
            507
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 5,
        "fee": "17000000000000000000"
    },
    {
        "id": 81,
        "name": "",
        "typeId": 1,
        "minLevel": 30,
        "careers": [
            2,
            6
        ],
        "material": [
            4,
            8,
            35,
            36
        ],
        "materialNum": [
            250,
            275,
            700,
            850
        ],
        "mainValues": [
            445,
            465
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 5,
        "fee": "17000000000000000000"
    },
    {
        "id": 82,
        "name": "",
        "typeId": 2,
        "minLevel": 30,
        "careers": [
            1,
            4
        ],
        "material": [
            4,
            8,
            22,
            23,
            30
        ],
        "materialNum": [
            300,
            225,
            300,
            900,
            350
        ],
        "mainValues": [
            81,
            91
        ],
        "valueType": 1,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 5,
        "fee": "17000000000000000000"
    },
    {
        "id": 83,
        "name": "",
        "typeId": 2,
        "minLevel": 30,
        "careers": [
            3
        ],
        "material": [
            8,
            22,
            23,
            31
        ],
        "materialNum": [
            250,
            950,
            450,
            425
        ],
        "mainValues": [
            156,
            166
        ],
        "valueType": 2,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 5,
        "fee": "17000000000000000000"
    },
    {
        "id": 84,
        "name": "",
        "typeId": 2,
        "minLevel": 30,
        "careers": [
            2,
            6
        ],
        "material": [
            8,
            30,
            31
        ],
        "materialNum": [
            300,
            950,
            825
        ],
        "mainValues": [
            147,
            157
        ],
        "valueType": 3,
        "inlayNum": 10,
        "quality": 5,
        "durable": 50,
        "unit": 1,
        "star": 5,
        "fee": "17000000000000000000"
    }
];

export {
    EquipmentArray
};