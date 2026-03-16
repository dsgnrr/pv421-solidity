// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

interface  IContractA {
    function set_value(uint value) external;
    function get_value() external view returns(uint);
    function pay() external payable;
}

contract ContractA is IContractA{
    uint _value; //0
    address public owner; //1

    function set_value(uint value)external {
        owner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        _value = value; 
    }

    function get_value() external view returns (uint){
        return _value;
    }

    function pay() external payable {}

    fallback() external payable { console.log("fallback"); }

    receive() external payable { console.log("recieve"); }
}
/*
 call -> transact, view, pure, payable
 delegatecall -> view, pure, transact
 staticcall -> view, pure
 interface -> transact, view, pure, payable
*/

contract ContractB{

   
    // contract address - адреса контракту методу якого будуть викликатися в іншому контракті


    uint public value; //0
    address public owner; //1
    address public contract_a; //2

    constructor(address other_contract){
        contract_a = other_contract;
        owner = msg.sender;
    }

    function only_owner() public view returns(string memory){
        require(owner == msg.sender, "You're not owner");
        return "Success";
    }

    function callGetSetValue(uint n_value) public returns(uint){
        // ABI - application binnary interface
        // set_value(uint256)
        (bool set_result, ) = contract_a.call(abi.encodeWithSignature("set_value(uint256)", n_value));
        require(set_result, "set_value call unsuccessfull");

        (bool get_result, bytes memory data) = contract_a.call(abi.encodeWithSignature("get_value()"));
        require(get_result, "get_value call unsuccessfull");
        return abi.decode(data, (uint));
    }

    function callPayable() public payable{
        (bool result, ) = contract_a.call{value: msg.value}(abi.encodeWithSignature("pay()"));
        require(result, "Pay is not working");
    }

    function delegateSetValue(uint n_value) public{
        // ABI - application binnary interface
        // set_value(uint256)
        (bool set_result, ) = contract_a.delegatecall(abi.encodeWithSignature("set_value(uint256)", n_value));
        require(set_result, "set_value call unsuccessfull");
    }

    function staticcallGetValue() public view returns(uint){
        (bool get_result, bytes memory data) = contract_a.staticcall(abi.encodeWithSignature("get_value()"));
        require(get_result, "get_value call unsuccessfull");
        return abi.decode(data, (uint));
    }

    function interface_call(uint n_value) public payable returns(uint){
        IContractA(contract_a).set_value(n_value);
        IContractA(contract_a).pay{value:msg.value}();
        return  IContractA(contract_a).get_value();
    }
}