// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// 导入OpenZeppelin的IERC20接口
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// VaultDAO合约：用于管理和控制资金
contract VaultDAO {
    // 多签钱包地址
    address public multSigAddress;
    
    // 构造函数：初始化多签钱包地址
    // @param _multSigAddress 多签钱包地址
    constructor(address _multSigAddress) {
        multSigAddress = _multSigAddress;
    }

    // 修饰符：限制只有多签钱包可以调用
    modifier onlyMultSig() {
        require(msg.sender == multSigAddress, "MsgSender not is multSigAddress");
        _;
    }

    // 提取代币函数
    // @param tokenAddr 要提取的代币地址
    // @param to 接收代币的地址
    // @param amount 要提取的代币数量
    function withdraw(address tokenAddr, address to, uint256 amount) public onlyMultSig {
        // 获取合约中代币余额
        uint256 bal = IERC20(tokenAddr).balanceOf(address(this));
        // 如果余额不足，则提取全部余额
        if (bal < amount) {
            amount = bal;
        }

        // 转账代币到指定地址
        IERC20(tokenAddr).transfer(to, amount);
    }
}

