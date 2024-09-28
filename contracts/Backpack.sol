// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CallerMgr.sol";

contract Backpack is Ownable, CallerMgr {
    uint256 public maxTokenId;
    mapping(uint256 => uint256) _balances;

    // Constructor: Sets up the initial caller
    constructor() {
        _setupCaller(msg.sender);
    }

    // Modifier: Updates maxTokenId if a larger tokenId is encountered
    modifier changeMaxTokenId(uint256 tokenId) {
        if (tokenId > maxTokenId) {
            maxTokenId = tokenId;
        }
        _;
    }

    // Transfers tokens from this contract to a specified address
    function transfer(address token, address to, uint256 amount) external onlyOwner {
        IERC20(token).transfer(to, amount);
    }

    // Claims tokens on behalf of an owner and transfers them
    function claim(address owner, address token, uint256 amount) external onlyOwner {
        IERC20(token).transfer(owner, amount);
    }

    // Adds balance to a specific tokenId, updating maxTokenId if necessary
    function addBalance(uint256 tokenId, uint256 amount) external changeMaxTokenId(tokenId) onlyOwner {
        _balances[tokenId] += amount;
    }

    // Subtracts balance from a specific tokenId, ensuring sufficient balance
    function subBalance(uint256 tokenId, uint256 amount) external onlyOwner {
        uint256 bal = _balances[tokenId];
        require(bal >= amount, "Insufficient account balance");
        _balances[tokenId] = bal - amount;
    }

    // Retrieves the balance of a specific tokenId
    function getBalance(uint256 tokenId) external view returns (uint256) {
        return _balances[tokenId];
    }

    // Retrieves all balances up to the current maxTokenId
    function getAllBalances() external view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](maxTokenId);
        for (uint i = 0; i < maxTokenId; i++) {
            balances[i] = _balances[i + 1];
        }
        return balances;
    }
}
