// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IBlast {
  function configureAutomaticYield() external;
  function configureClaimableYield() external;
  function claimYield(address contractAddress, address recipientOfYield, uint256 amount) external returns (uint256);
  function claimAllYield(address contractAddress, address recipientOfYield) external returns (uint256);

  function configureClaimableGas() external;
  function claimAllGas(address contractAddress, address recipient) external returns (uint256);
}

interface IBlastPoints {
	function configurePointsOperator(address operator) external;
}

enum YieldMode {
  AUTOMATIC,
  VOID,
  CLAIMABLE
}

interface IERC20Rebasing {
  // changes the yield mode of the caller and update the balance
  // to reflect the configuration
  function configure(YieldMode) external returns (uint256);
  // "claimable" yield mode accounts can call this this claim their yield
  // to another address
  function claim(address recipient, uint256 amount) external returns (uint256);
  // read the claimable amount for an account
  function getClaimableAmount(address account) external view returns (uint256);
}