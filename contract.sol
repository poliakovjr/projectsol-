// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract firstContract {
    mapping (address => bool) buyers;
    uint256 public price = 2 ether;
    address public owner;
    address public shopAddress;
    bool fullyPaid; // false
    
    event ItemFullyPaid(uint _price, address _shopAddress);

    constructor() {
        owner = msg.sender;
        shopAddress = address(this);
    }
    
    function getBuyer(address _addr) public view returns(bool) {
        require(owner == msg.sender, "You are not an owner!");
        
        return buyers[_addr];
    }
    
    function addBuyer(address _addr) public {
        require(owner == msg.sender, "You are not an owner!");
        
        buyers[_addr] = true;
    }
    
    function getBalance() public view returns(uint) {
        return shopAddress.balance;
    }
    
    function withdrawAll() public {
        require(owner == msg.sender && fullyPaid && shopAddress.balance > 0, "Reject");
        
        address payable receiver = payable(msg.sender);
        
        receiver.transfer(shopAddress.balance);
    }
    
    receive() external payable {
        require(buyers[msg.sender] && msg.value <= price && !fullyPaid, "Reject");
        
        if(shopAddress.balance == price) {
            fullyPaid = true;
            
            emit ItemFullyPaid(price, shopAddress);
        }
    }
}