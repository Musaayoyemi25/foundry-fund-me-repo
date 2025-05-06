// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether; //10 ETH
    //uint256 constant GAS_PRICE = 1; //1 wei
    function setUp() external {
        // us -> FundMeTest -> FundMe
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE); //gives the user 10 ETH
    }

    function testUserCanFundInteractions() public {
        // Arrange
        FundFundMe fundFundMe = new FundFundMe();
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        // Give ETH to the test contract first
        vm.deal(address(this), STARTING_BALANCE);

        // Fund through script
        fundFundMe.fundFundMe{value: SEND_VALUE}(address(fundMe));

        // Verify funding worked
        assertEq(
            fundMe.getAddressToAmountFunded(address(fundFundMe)),
            SEND_VALUE
        );
        assertEq(address(fundMe).balance, SEND_VALUE);

        // Withdraw as owner (no broadcast needed in test environment)
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        assertEq(address(fundMe).balance, 0);

        // Verify owner received funds
        assertGt(fundMe.getOwner().balance, 0);
    }
}
