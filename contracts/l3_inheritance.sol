// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Parent{
    uint private private_field;

    string internal message = "Hello from parent";

    function get_state() public view virtual returns(string memory, string memory){
        return("Parent", message);
    }

    function method() pure public virtual returns(string memory){
        return "Parent";
    }
}

contract Child is Parent{

    constructor(){
        message = "Hello from child";
    }

    function get_message()external view returns(string memory){
        return message;
    }

    function get_state() public view override returns(string memory, string memory){
        return("Child", message);
    }

    
}

abstract contract Token{
    uint internal coins;
    function mint() internal virtual;
    function get_coins_count() external virtual returns(uint);

    function method() pure public virtual returns(string memory){
        return "Token";
    }
}

contract AwesomeToken is Token{

    constructor(){ mint();}
    function mint() internal override{
        coins = 1999999999999999999999;
    }
    function get_coins_count() external view override returns(uint){
        return coins;
    }
}

contract MultiplyExtends is Parent, Token{
    function mint() internal override{
        coins = 1999999999999999999999;
    }
    function get_coins_count() external view override returns(uint){
        return coins;
    }
    function method() pure public override(Token, Parent) returns(string memory){
        return "ME";
    }
}