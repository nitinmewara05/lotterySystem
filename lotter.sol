// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "contracts/userRecord.sol";


contract lotteryContract{
address blockAdmin;

mapping(uint => UserRecord) public lotteryUsersList;

UserRecord userRecord;
UserRecord public  winner;
bool resultDeclared;
uint Ticket_Amount;
uint userCount;
uint totalBalance;
uint userlimit;
address[] userAddressList;
constructor(){
    blockAdmin = msg.sender;
    Ticket_Amount = 500;
    userCount = 0;
    totalBalance = 0;
userlimit = 5;
resultDeclared = false;
}
modifier checkBlockAdmin(){
    require(msg.sender == blockAdmin, "Access deny... You are not admin!");
    _;
}
modifier checkTicketUser(){
    require(msg.sender != blockAdmin, "Access deny... You are not admin!");
    _;
}
modifier resultStatus(){
    require(resultDeclared== false, "result has been declared already");
    _;
}

modifier checkUserCount(){
require(userCount < userlimit, "Error : Tickets Over");
    _;
}
modifier checkTicketUserCount(){
    address userAccount;
    uint cnt = 0;
    bool token = false;
    while(cnt<userCount){
        userAccount == userAddressList[cnt];
        if (userAccount == msg.sender)
        {
            token = true;
            break ;
        } 
        cnt++;
    }
    require(token==false,"Error, You have already purchased ticket");
    _;
}


function purchaseTicket(string memory userName) public checkTicketUser() checkTicketUserCount() checkUserCount() {
   userAddressList.push(msg.sender);
    userRecord = UserRecord(msg.sender, userName, Ticket_Amount,0);
    lotteryUsersList[userCount] = userRecord;
    totalBalance += Ticket_Amount;
    userCount++;
}

function getWinner() public checkBlockAdmin() resultStatus(){
uint startValue=0;
uint winnerIndex = uint(keccak256(abi.encodePacked(msg.sender, block.timestamp, startValue)))%userlimit;
winner = lotteryUsersList[winnerIndex];
winner = UserRecord(winner.userAccount,winner.name,winner.winningAmount,totalBalance);
resultDeclared = true;
} 

}