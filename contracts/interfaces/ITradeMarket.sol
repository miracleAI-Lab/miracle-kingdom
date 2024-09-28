// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "../libraries/GameLib.sol";

interface ITradeMarket {
    function getProps() external view returns (GameLib.Prop[] memory);

    function getProp(uint256 propId) external view returns (GameLib.Prop memory);
}
