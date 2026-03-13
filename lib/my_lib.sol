// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

library MyLib{

    struct Person{
        string name;
        string surname;
        uint age;
    }

    function get_random_person(uint age)pure public returns(Person memory){
        return Person(
            "Tom",
            "Due",
            age
        );
    }

    function sum(uint a, uint b) pure external returns(uint){
        return a + b;
    }

    function get_max(uint a, uint b) pure external returns(uint){
        return a>b? a: b;
    }
}