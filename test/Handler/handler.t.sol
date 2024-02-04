// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Registry} from "../../src/Registry.sol";

contract Handler is Test {
    Registry registry;
    address alice;

    constructor(Registry _registry, address _alice) {
        registry = _registry;
        alice = _alice;
    }

    function register(uint256 _amount) public {
        uint256 amountToPay = 4e18;
        uint256 startingPay = registry.PRICE();
        uint256 amount = bound(_amount, startingPay, amountToPay);
        vm.deal(alice, amount);
        vm.startPrank(alice);
        registry.register{value: amount}();
        vm.stopPrank();
    }
}
