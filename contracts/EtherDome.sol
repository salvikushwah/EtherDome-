// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title EtherDome
 * @notice A decentralized vault that allows users to deposit, withdraw, 
 *         and view their Ether balance securely on-chain.
 */
contract Project {
    address public owner;
    mapping(address => uint256) private balances;
    uint256 public totalDeposits;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Deposit Ether into your account in the EtherDome vault.
     */
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw Ether from your account.
     * @param _amount Amount of Ether (in wei) to withdraw.
     */
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        totalDeposits -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawn(msg.sender, _amount);
    }

    /**
     * @notice Get your current deposited balance.
     * @return The Ether balance of the caller.
     */
    function getMyBalance() external view returns (uint256) {
        return balances[msg.sender];
    }

    /**
     * @notice Owner can transfer contract ownership.
     * @param _newOwner Address of the new owner.
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        address oldOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(oldOwner, _newOwner);
    }
}
