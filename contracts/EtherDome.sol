? Function 1: Deposit Ether into the vault
    function deposit() public payable {
        require(msg.value > 0, "Must send some Ether");

        depositCount++;
        deposits[depositCount] = Deposit(depositCount, msg.sender, msg.value, block.timestamp, false);

        emit Deposited(depositCount, msg.sender, msg.value);
    }

    ? Function 3: View deposit details
    function getDeposit(uint256 _id) public view returns (Deposit memory) {
        require(_id > 0 && _id <= depositCount, "Invalid deposit ID");
        return deposits[_id];
    }
}
// 
update
// 
