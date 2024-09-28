// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.11;

// 导入OpenZeppelin的ERC20和Ownable合约
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 用于测试的USDT代币合约
contract UsdtToken is Ownable, ERC20("USDT Token", "USDT") {

    // 构造函数
    constructor() {
        // 铸造100亿个USDT代币给合约部署者
        _mint(_msgSender(), 10000000000 * 1e18);
    }
}