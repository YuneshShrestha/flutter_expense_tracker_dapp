// SPDX-License-Identifier: MIT
pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;

contract ExpenseManager {
  address public owner;

  event Deposit(address indexed _from, uint _amount, string _reason, uint _timestamp);

  event Withdrawal(address indexed _to, uint _amount, string _reason, uint _timestamp);

  struct Transaction{
    address user;
    uint amount;
    string reason;
    uint timestamp;
  }

  mapping(address => uint) public balances;
  Transaction[] public transactions;


  constructor()  public{
    owner = msg.sender;
  }

  modifier onlyOwner()
  {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  function deposit(uint amount, string memory reason) public payable{
    require(amount > 0, "Amount should be greater than 0");
    balances[msg.sender] += amount;
    transactions.push(Transaction(msg.sender, amount, reason, block.timestamp));
    emit Deposit(msg.sender, amount, reason, block.timestamp);
  }

  function withdraw(uint _amount, string memory _reason) public{
    require(balances[msg.sender] >= _amount, "Insufficient balance");
    balances[msg.sender] -= _amount;
    transactions.push(Transaction(msg.sender, _amount, _reason, block.timestamp));
    address(uint160(msg.sender)).transfer(_amount);
    emit Withdrawal(msg.sender, _amount, _reason, block.timestamp);
  }

  function getBalance(address _account) public view returns(uint){
    return balances[_account];
  }

  function getTransactionsCount() public view returns(uint){

    return transactions.length;
  }

  function getTransaction(uint index) public view returns(address, uint, string memory, uint){
    require(
        index < transactions.length,
        "Transaction index out of bounds"
    );
    Transaction memory transaction = transactions[index];
    return (
      transaction.user,
      transaction.amount,
      transaction.reason,
      transaction.timestamp
    );

  }

  function getAllTransactions() public returns(address[] memory, uint[] memory, string[] memory, uint[] memory){
    address[] memory users = new address[](transactions.length);
    uint[] memory amounts = new uint[](
      transactions.length
    );
    string[] memory reasons = new string[](
      transactions.length
    );
    uint[] memory timestamps = new uint[](
      transactions.length
    );

    for (uint index = 0; index < transactions.length; index++) {
      users[index] = transactions[index].user;
      amounts[index] = transactions[index].amount;
      reasons[index] = transactions[index].reason;
      timestamps[index] = transactions[index].timestamp;
    }
    return (users, amounts, reasons, timestamps);
  }
  
  function changeOwner(address _newOwner) public onlyOwner{
    owner = _newOwner;
  } 
}
