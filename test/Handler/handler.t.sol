// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Registry} from "../../src/Registry.sol";

contract Handler is Test {
    Registry public registry;
    address public alice;
    uint256 public trackingbalances;
    uint256 ContractAmountSupply = 8 ether;

    constructor(Registry _registry, address _alice) {
        registry = _registry;
        alice = _alice;
        deal(address(this), ContractAmountSupply);
    }

    function register(uint256 _amount) public {
        uint256 startingAmount = 2 ether;
        uint256 amount = bound(_amount, startingAmount, address(this).balance);
        // require is required
        require(amount > startingAmount && amount < address(this).balance);
        vm.deal(alice, amount);
        vm.startPrank(alice);
        registry.register{value: amount}();
        vm.stopPrank();
        trackingbalances+=amount;
    }
}
