// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// 国库合约，用于管理USDT和CORE代币
contract Treasury {
    IERC20 public usdtToken;  // USDT代币合约接口
    IERC20 public coreToken;  // CORE代币合约接口
    address public multSigAddress;  // 多签钱包地址
    
    // 构造函数，初始化多签地址和代币合约
    constructor(address _multSigAddress, IERC20 _usdtToken, IERC20 _coreToken) {
        multSigAddress = _multSigAddress;
        usdtToken = _usdtToken;
        coreToken = _coreToken;
    }

    // 修饰器：只允许多签钱包地址调用
    modifier onlyMultSig() {
        require(msg.sender == multSigAddress, "MsgSender not is multSigAddress");
        _;
    }

    // 根据代币类型提取指定数量的代币
    function withdrawWithType(uint tokenType, address to, uint256 amount) public onlyMultSig {
        IERC20 token = tokenType == 1 ? usdtToken : coreToken;  // 选择要提取的代币
        uint256 bal = token.balanceOf(address(this));  // 获取合约中代币余额
        if (bal < amount) {
            amount = bal;  // 如果余额不足，则提取全部余额
        }

        token.transfer(to, amount);  // 转账给指定地址
    }

    // 提取指定地址的代币
    function withdraw(address tokenAddr, address to, uint256 amount) public onlyMultSig {
        uint256 bal = IERC20(tokenAddr).balanceOf(address(this));  // 获取合约中指定代币的余额
        if (bal < amount) {
            amount = bal;  // 如果余额不足，则提取全部余额
        }

        IERC20(tokenAddr).transfer(to, amount);  // 转账给指定地址
    }
}
