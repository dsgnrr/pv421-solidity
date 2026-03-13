// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";
import "lib/my_lib.sol";


contract Sample{

    using MyLib for uint;
    using console for string;

    error NotOwner(address from);

    error MinValueError(uint expected, uint current);

    event DonateEvent(address indexed sender, uint value);

    event WithdrawEvent(uint value);

    modifier isOwner(){
        console.log("modifier: isOwner");
        // state++;
        // require(owner == msg.sender, "You're not owner");
        require(owner == msg.sender, NotOwner(msg.sender));
        _;
    }

    modifier minValue(uint min_value){
        require(msg.value >= min_value, MinValueError(min_value, msg.value));
        _;
    }

    address owner;

    int public state = 0;


    constructor(){
        owner = msg.sender;
        string memory log = "Contract successfully deployed";
        log.log();
    }

    function get_person() pure public returns(MyLib.Person memory){
        uint value = 22;
        return value.get_random_person();
    }

    function add_ten(uint value) pure public returns(uint){

        console.log("Get max: your value-> %d, other->10. Max-> %d", value, value.get_max(10));

        return value.sum(10);
    }

    function sum(uint v1, uint v2)public pure returns(uint){
        return MyLib.sum(v1, v2);
    }

    function get_max(uint v1, uint v2)public pure returns(uint){
        return MyLib.get_max(v1,v2);
    }

    function donate() external minValue(2000) payable{
        console.log("!!!!!!New donate!!!!!!!!");
        emit DonateEvent(msg.sender, msg.value);
    }

    function withdraw() external isOwner{
        // state = 1;
        // if(msg.sender != owner){
        //     // return;
        //     // revert("You're not owner");
        //     revert NotOwner(msg.sender);
        // }

        // assert(owner == msg.sender);

        uint contract_balance = address(this).balance;
        payable(msg.sender).transfer(address(this).balance);
        console.log("Owner gets ETH from contract!");
        emit WithdrawEvent(contract_balance);
    }

    function only_owner() external view isOwner returns(string memory){
        return "Success";
    }
}