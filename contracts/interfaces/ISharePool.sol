// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../libraries/GameLib.sol";

interface ISharePool {
    function addRewards(uint256 amountToken) external;
}
