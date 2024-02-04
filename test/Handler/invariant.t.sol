// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Registry} from "../../src/Registry.sol";
import {Handler} from "./handler.t.sol";

contract InvariantBreak is StdInvariant, Test {
    Registry registry;
    Handler handler;
    address alice = makeAddr("alice");
    uint256 startingAmount;

    function setUp() public {
        vm.deal(alice, 4 ether);
        vm.startPrank(alice);
        registry = new Registry();
        startingAmount = 4 ether;
        registry.register{value: startingAmount}();
        vm.stopPrank();

        handler = new Handler(registry, alice);

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = handler.register.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function statefulFuzz__testInvariantBreaksHandler() public {
        assert(address(alice).balance < address(registry).balance);

        assert(address(registry).balance > address(alice).balance);

        assert(registry.isRegistered(alice) == true);
    }
}
