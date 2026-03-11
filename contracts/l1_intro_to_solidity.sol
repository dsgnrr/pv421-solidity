// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

contract SecondContract{
    
}

contract FirstContract{
    // state

    /*
    // functions, fields(attrs, state)
    public - доступ до данних є як в самому контракті так і зовні
    private - доступ тільки в контракті
    external - доступ тільки зовні
    internal(~protected) - доступ тільки в контракті та його нащадках
    */

    // bool, int, uint, address
    // [], [][] 
    // string
    // struct
    // enum

    /*
    + - / * 
    > < >= <=
    || - or
    && - and
    !
    */
    bool public bool_value = true;

    // address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; 
    address public owner; 

    constructor() {
        // msg:
        //  -value(uint256): скільки веі було надіслано на цей контракт
        //  - sender(address): хто ініціював транзакцію
        owner = msg.sender;

        // address:
        //     - balance(uint256): стан балансу аккаунта
        //     - transfer(value:uint256) - функція, яка дозволяє нарахувати вей на цей акаунт

        console.log("Congratulations: You deployed your contract");
        console.log("Your balance", owner.balance);
    }

    string public str1 = "string";

    // memory - mutable, тимчасовий елемент, який знищується після виконання функції. Можна записати нове значення у функції.
    // calldata - readonly. Дешевший за memory.
    // Calldata та memory використовується для параметрів функції(або у return) тільки якщо вони є масивом або об'єктом структури або string
    function set_string(string calldata newstr) external{
        str1 = newstr;
        // newstr="new";
    } 

    // Arrays

    uint[5] public fixed_array = [1,2,3,4];

    // data_type[cols][rows]

    uint [3][2] public array2d =[
        [1,2,3],
        [4,5,6]
    ];

    uint[] public dynamic_array;

    function init_array(uint[] calldata init) public{
        // []:
        // length:uint - property
        // push(item) - method
        // pop()
        // index

        for(uint idx; idx<init.length; idx++){
            console.log("%d - %d", idx, init[idx]);
            dynamic_array.push(init[idx]);
        }
    }

    function pop() public{
        console.log("The last item: %d", dynamic_array[dynamic_array.length - 1]);
        dynamic_array.pop();
    }

    function print_array() public view{
        console.log("dynamic_array: ");
        for(uint idx; idx<dynamic_array.length; idx++){
            console.log("%d - %d", idx, dynamic_array[idx]);
        }
    }

    function remove_by_index(uint idx) public{
        if(idx > dynamic_array.length-1){
            revert("Index out of bounds of array");
        }
        delete dynamic_array[idx];
    }

    function create_array() public pure returns(uint[] memory new_array){
        new_array = new uint[](5);
        new_array[0] = 45;
        new_array[1] = 10;
        new_array[2] = 32;
        new_array[3] = 56;
        new_array[4] = 190;
        return new_array;
    }

    // mapping ~ dictionaries
    // mapping(key_type=>value_type) access_level <name>;

    mapping(address => uint) public balances;

    function write_balance() public{
        balances[msg.sender] = msg.sender.balance;
    }

    // byte-arrays

    bytes1 public one_byte = "b";

    bytes32 public bytes_fixed = "Hello, world";

    bytes public bytes_dynamic = "Hello, world";

    function decode() public view returns(string memory){
        return string(bytes_dynamic);
    }

    // enums

    enum Status {Paid, Delievered, Recieved}

    Status public product_status = Status.Delievered;

    // struct

    struct Payment{
        uint value;
        uint timestamp;
        address from;
        string message;
    }

    Payment public last_payment;

    function create_payment(string memory message) public payable{
        last_payment = Payment(
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );
    }

    // function transfer(address payable to) public payable{
    //     to.transfer(msg.value);
    // }

    function transfer(address to) public payable{
        payable(to).transfer(msg.value);
    }

    /*
        transact - це ф-ції які працюють зі станом контракту, а саме змінюють цей стан. Такі функції обгортаються у транзакцію. За їх виклик користувач платить комісію.
        Ціна залежить від кількості використаного палива для виконання цієї функції.

        view - це ф-ції які також працюють зі станом контракту, але у режимі read-only. Фактично вони дозволяють читати стан контракту, при цьому користувач не платить комісію
        за виконання таких функцій. Читання стану безкоштовне.

        pure - це ф-ції які не можуть працювати зі станом контракту взагалі, в них доступ до стану закритий. Такі ф-ції використовуються як службові. Обчислення на місці і одразу повернення
        результату. За їх виклик користувач не платить комісію

        view та pure ф-ції не обгортаються у транзакцію. Для них використовується механізм call.
    
    */

    string view_str = "contract state";

    function view_get_string() public view returns(string memory){
        return view_str;
    }

    function pure_get_string() public pure returns(string memory){
        
        // !Помилка: pure-функції не мають доступу до стану контракта.
        // return view_str;
        return "Pure";
    }
}