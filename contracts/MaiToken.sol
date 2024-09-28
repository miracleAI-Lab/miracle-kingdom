// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.11;

// 导入 OpenZeppelin 的 ERC20 合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// MaiToken 合约，继承自 ERC20
contract MaiToken is ERC20("Miracle AI", "MAI3") {

    // 构造函数
    constructor() {
        // 铸造 10 亿个代币，并将其分配给合约部署者
        // 1e18 表示 18 位小数，这是 ERC20 代币的标准精度
        _mint(msg.sender, 1_000_000_000 * 1e18);
    }
}