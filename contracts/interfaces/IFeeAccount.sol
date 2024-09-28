// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IFeeAccount {
    function transfer(address to, uint256 amount) external;

    function transferToFeeTreasury(uint256 amount) external;

    function addRewardsToSharePool(uint256 sharePoolAmount) external;
}