// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// Import the IERC20 interface from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Contract for locking team tokens
contract TeamLock {
    // The ERC20 token that will be locked
    IERC20 public coreToken;
    // The address of the multi-signature wallet that can control this contract
    address public multSigAddress;
    
    // Constructor to initialize the contract
    // @param _multSigAddress The address of the multi-signature wallet
    // @param _coreToken The address of the ERC20 token to be locked
    constructor(address _multSigAddress, IERC20 _coreToken) {
        multSigAddress = _multSigAddress;
        coreToken = _coreToken;
    }

    // Modifier to restrict function access to only the multi-signature wallet
    modifier onlyMultSig() {
        require(msg.sender == multSigAddress, "MsgSender not is multSigAddress");
        _;
    }

    // Function to withdraw tokens from the contract
    // Can only be called by the multi-signature wallet
    // @param to The address to receive the withdrawn tokens
    // @param amount The amount of tokens to withdraw
    function withdraw(address to, uint256 amount) public onlyMultSig {
        // Get the current balance of tokens in the contract
        uint256 bal = coreToken.balanceOf(address(this));
        // If the requested amount is more than the balance, withdraw the entire balance
        if (bal < amount) {
            amount = bal;
        }

        // Transfer the tokens to the specified address
        coreToken.transfer(to, amount);
    }
}

