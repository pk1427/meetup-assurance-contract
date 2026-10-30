// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

/// @notice A no-admin assurance contract: terms cannot change after deployment.
contract AssuranceCampaign is ReentrancyGuard {
    uint256 public immutable target;
    uint256 public immutable deadline;
    address payable public immutable beneficiary;
    mapping(address => uint256) public pledges;
    uint256 public totalPledged;
    uint256 public bonus;
    bool public collected;

    event Pledged(address indexed pledger, uint256 amount);
    event BonusFunded(uint256 amount);
    event Collected(uint256 amount);
    event Refunded(address indexed pledger, uint256 amount);

    constructor(uint256 target_, uint256 deadline_, address payable beneficiary_) {
        require(target_ > 0 && deadline_ > block.timestamp && beneficiary_ != address(0), "bad terms");
        target = target_; deadline = deadline_; beneficiary = beneficiary_;
    }
    function pledge() external payable {
        require(block.timestamp <= deadline, "pledging ended"); require(msg.value > 0, "zero pledge");
        pledges[msg.sender] += msg.value; totalPledged += msg.value;
        emit Pledged(msg.sender, msg.value);
    }
    function fundBonus() external payable {
        require(msg.sender == beneficiary, "beneficiary only"); require(block.timestamp <= deadline, "campaign ended");
        require(msg.value > 0, "zero bonus"); bonus += msg.value; emit BonusFunded(msg.value);
    }
    function collect() external nonReentrant {
        require(msg.sender == beneficiary, "beneficiary only"); require(block.timestamp > deadline, "too early");
        require(totalPledged >= target, "target missed"); require(!collected, "already collected");
        collected = true; // effects before interaction
        uint256 amount = address(this).balance;
        (bool ok,) = beneficiary.call{value: amount}(""); require(ok, "transfer failed"); emit Collected(amount);
    }
    function refund() external nonReentrant {
        require(block.timestamp > deadline, "too early"); require(totalPledged < target, "target met");
        uint256 pledged = pledges[msg.sender]; require(pledged > 0, "nothing to refund");
        pledges[msg.sender] = 0; // effects before interaction
        uint256 share = bonus == 0 ? 0 : bonus * pledged / totalPledged;
        uint256 amount = pledged + share;
        (bool ok,) = payable(msg.sender).call{value: amount}(""); require(ok, "transfer failed"); emit Refunded(msg.sender, amount);
    }
    function timeLeft() external view returns (uint256) { return block.timestamp >= deadline ? 0 : deadline - block.timestamp; }
    function pledgeOf(address who) external view returns (uint256) { return pledges[who]; }
    function status() external view returns (string memory) {
        if (collected) return "Collected";
        if (block.timestamp <= deadline) return "Active";
        return totalPledged >= target ? "Succeeded" : "Failed";
    }
}
