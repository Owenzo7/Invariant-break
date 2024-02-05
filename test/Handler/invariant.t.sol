// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Registry} from "../../src/Registry.sol";
import {Handler} from "./handler.t.sol";

contract InvariantBreak is StdInvariant, Test {
    Registry registry;
    Handler handler;
    address alice = makeAddr("alice");
    uint256 startingAmount;

    function setUp() public {
        registry = new Registry();

        handler = new Handler(registry, alice);

        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = handler.register.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
        targetContract(address(handler));
    }

    function invariant_testRegistry() public {
        // assert(address(handler).balance == address(handler.registry()).balance + address(handler.alice()).balance);

        assertTrue(registry.isRegistered(handler.alice()), "Alice is not registered");

        // assert(address(handler).balance < handler.trackingbalances());

        console.log("handler balance:", handler.trackingbalances());
        console.log("Registry Entry Amount:", registry.PRICE());
        // vm.expectRevert();

     

        // assert(handler.trackingbalances() > address(handler).balance);
        // assert(handler.trackingbalances() == address(alice).balance + handler.trackingbalances());
    }
}
