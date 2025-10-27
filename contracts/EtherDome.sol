// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EtherDome
 * @dev A decentralized vault where users can deposit and withdraw Ether securely.
 */
contract Project {
    address public admin;
    uint256 public depositCount;

    struct Deposit {
        uint256 id;
        address depositor;
        uint256 amount;
        uint256 timestamp;
        bool withdrawn;
    }

    mapping(uint256 => Deposit) public deposits;

    event Deposited(uint256 indexed id, address indexed depositor, uint256 amount);
    event Withdrawn(uint256 indexed id, address indexed depositor, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // ✅ Function 1: Deposit Ether into the vault
    function deposit() public payable {
        require(msg.value > 0, "Must send some Ether");

        depositCount++;
        deposits[depositCount] = Deposit(depositCount, msg.sender, msg.value, block.timestamp, false);

        emit Deposited(depositCount, msg.sender, msg.value);
    }

    // ✅ Function 2: Withdraw Ether (only admin can approve)
    function withdraw(uint256 _id) public onlyAdmin {
        Deposit storage d = deposits[_id];
        require(!d.withdrawn, "Already withdrawn");
        d.withdrawn = true;

        payable(d.depositor).transfer(d.amount);
        emit Withdrawn(_id, d.depositor, d.amount);
    }

    // ✅ Function 3: View deposit details
    function getDeposit(uint256 _id) public view returns (Deposit memory) {
        require(_id > 0 && _id <= depositCount, "Invalid deposit ID");
        return deposits[_id];
    }
}
