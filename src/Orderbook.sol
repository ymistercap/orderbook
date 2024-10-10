// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Orderbook {
    struct Order {
        uint256 id;
        address user;
        uint256 amount;
        uint256 price;
        bool isBuyOrder;
    }

    uint256 public nextOrderId;
    mapping(uint256 => Order) public orders;
    mapping(address => mapping(uint256 => uint256)) public userOrders; 

    event OrderPlaced(uint256 indexed orderId, address indexed user, uint256 amount, uint256 price, bool isBuyOrder);
    event OrdersMatched(uint256 indexed buyOrderId, uint256 indexed sellOrderId, uint256 amount);

    function placeBuyOrder(uint256 amount, uint256 price) external {
        nextOrderId++;
        orders[nextOrderId] = Order(nextOrderId, msg.sender, amount, price, true);
        userOrders[msg.sender][nextOrderId] = nextOrderId;

        emit OrderPlaced(nextOrderId, msg.sender, amount, price, true);
        matchOrders();
    }

    function placeSellOrder(uint256 amount, uint256 price) external {
        nextOrderId++;
        orders[nextOrderId] = Order(nextOrderId, msg.sender, amount, price, false);
        userOrders[msg.sender][nextOrderId] = nextOrderId;

        emit OrderPlaced(nextOrderId, msg.sender, amount, price, false);
        matchOrders();
    }

    function matchOrders() internal {
        for (uint256 buyOrderId = 1; buyOrderId <= nextOrderId; buyOrderId++) {
            if (orders[buyOrderId].isBuyOrder) {
                for (uint256 sellOrderId = 1; sellOrderId <= nextOrderId; sellOrderId++) {
                    if (!orders[sellOrderId].isBuyOrder && orders[buyOrderId].price >= orders[sellOrderId].price) {
                    
                        uint256 amount = orders[buyOrderId].amount < orders[sellOrderId].amount ? orders[buyOrderId].amount : orders[sellOrderId].amount;

                        orders[buyOrderId].amount -= amount;
                        orders[sellOrderId].amount -= amount;

                        emit OrdersMatched(buyOrderId, sellOrderId, amount);
                        
                        if (orders[buyOrderId].amount == 0) {
                            delete orders[buyOrderId];
                            break;
                        }
                    }
                }
            }
        }
    }
}
