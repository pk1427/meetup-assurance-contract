// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {AssuranceCampaign} from "../src/AssuranceCampaign.sol";
interface Vm { function envUint(string calldata) external returns(uint256); function envAddress(string calldata) external returns(address); function startBroadcast(uint256) external; function stopBroadcast() external; }
contract Deploy { Vm constant vm=Vm(address(uint160(uint256(keccak256("hevm cheat code"))))); function run() external returns(AssuranceCampaign c) { uint256 key=vm.envUint("PRIVATE_KEY"); vm.startBroadcast(key); c=new AssuranceCampaign(vm.envUint("TARGET"),vm.envUint("DEADLINE"),payable(vm.envAddress("BENEFICIARY"))); vm.stopBroadcast(); } }
