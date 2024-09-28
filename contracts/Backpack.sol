// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CallerMgr.sol";

contract Backpack is Ownable, CallerMgr {
    uint256 public maxTokenId;
    mapping(uint256 => uint256) _balances;

    constructor() {
        _setupCaller(msg.sender);
    }

    modifier changeMaxTokenId(uint256 tokenId) {
        if (tokenId > maxTokenId) {
            maxTokenId = tokenId;
        }
        _;
    }

    function transfer(address token, address to, uint256 amount) external onlyOwner {
        IERC20(token).transfer(to, amount);
    }

    function claim(address owner, address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }

    function addBalance(uint256 tokenId, uint256 amount) external changeMaxTokenId(tokenId) onlyOwner {
        _balances[tokenId] += amount;
    }

    function subBalance(uint256 tokenId, uint256 amount) external onlyOwner {
        uint256 bal = _balances[tokenId];
        require(bal >= amount, "Insufficient account balance");
        _balances[tokenId] = bal - amount;
    }

    function getBalance(uint256 tokenId) external view returns (uint256) {
        return _balances[tokenId];
    }

    function getAllBalances() external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](maxTokenId);
        for (uint i = 0; i < maxTokenId; i++) {
            balances[i] = _balances[i + 1];
        }
        return balances;
    }
}
