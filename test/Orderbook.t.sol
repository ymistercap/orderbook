// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Orderbook.sol";

contract OrderbookTest is Test {
    Orderbook orderbook;

    function setUp() public {
        orderbook = new Orderbook();
    }

    function testPlaceBuyOrder() public {
        orderbook.placeBuyOrder(100, 1 ether);
        
        ( , address user, uint256 amount, uint256 price, bool isBuyOrder) = orderbook.orders(1);
        assertEq(user, address(this));
        assertEq(amount, 100);
        assertEq(price, 1 ether);
        assertTrue(isBuyOrder);
    }

    function testPlaceSellOrder() public {
        orderbook.placeSellOrder(100, 1 ether);
        
        ( , address user, uint256 amount, uint256 price, bool isBuyOrder) = orderbook.orders(2);
        assertEq(user, address(this));
        assertEq(amount, 100);
        assertEq(price, 1 ether);
        assertFalse(isBuyOrder);
    }

    function testMatchOrders() public {
        orderbook.placeBuyOrder(100, 1 ether);
        orderbook.placeSellOrder(100, 1 ether);
        
    }
}
