// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../unstoppable/UnstoppableLender.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

/**
 * @title ReceiverUnstoppable
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract BrokenReceiverUnstoppable {
    UnstoppableLender private immutable pool;
    address private immutable owner;

    constructor(address poolAddress) {
        pool = UnstoppableLender(poolAddress);
        owner = msg.sender;
    }

    // Pool will call this function during the flash loan
    function receiveTokens(address tokenAddress, uint256 amount) external {
        require(msg.sender == address(pool), "Sender must be pool");

        // Return all tokens to the pool
        console.log("contract address: ", address(this));
        console.log("owner address: ", owner);

        console.log(
            "contract balance: ",
            IERC20(tokenAddress).balanceOf(address(this))
        );
        console.log("owner balance: ", IERC20(tokenAddress).balanceOf(owner));

        require(
            IERC20(tokenAddress).transferFrom(owner, msg.sender, 1),
            "bloop"
        );

        console.log(
            "contract balance: ",
            IERC20(tokenAddress).balanceOf(address(this))
        );
        console.log("owner balance: ", IERC20(tokenAddress).balanceOf(owner));

        //console.log("it worked");
        //console.log('msg.sender balance ', IERC20(tokenAddress).balanceOf(msg.sender));

        // why is this not changing?
        //console.log('owner balance ', IERC20(tokenAddress).balanceOf(owner));

        require(
            IERC20(tokenAddress).transfer(msg.sender, amount),
            "Transfer of tokens failed"
        );
    }

    function executeFlashLoan(uint256 amount) external {
        require(msg.sender == owner, "Only owner can execute flash loan");
        //console.log("flash loan owner: ", owner);
        pool.flashLoan(amount);
    }
}
