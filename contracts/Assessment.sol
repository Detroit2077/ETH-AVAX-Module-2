// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//import "hardhat/console.sol";

contract Assessment {
    address payable public owner;
    uint256 public balance;
    uint256 public trasactionCount;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function deposit(uint256 _amount) public payable onlyOwner {
        require(_amount > 0, "Deposit amount should be greater than 0");
        uint _previousBalance = balance;
        balance += _amount;
        trasactionCount++;
        assert(balance == _previousBalance + _amount);
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;
        trasactionCount++;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }

    function TransferCurrency(uint256 _amount) public onlyOwner {
        require(_amount > 0, "Transfer amount should be greater than 0");
        uint _previousBalance = balance;
        balance -= _amount;
        trasactionCount++;
        assert(balance == (_previousBalance - _amount));
    }

    function transactionCount() public view returns (uint256) {
        return trasactionCount;
    }
}
