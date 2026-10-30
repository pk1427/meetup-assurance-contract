// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {AssuranceCampaign} from "../src/AssuranceCampaign.sol";
interface Vm { function warp(uint256) external; function prank(address) external; function deal(address,uint256) external; }
contract Reenter { AssuranceCampaign c; bool public tried; constructor(AssuranceCampaign x){c=x;} receive() external payable { if(!tried){tried=true; try c.refund() {} catch {} } } function pledge() external payable { c.pledge{value:msg.value}(); } function refund() external {c.refund();} }
contract AssuranceCampaignTest { Vm constant vm=Vm(address(uint160(uint256(keccak256("hevm cheat code"))))); address payable ben=payable(address(0xBEEF)); address alice=address(0xA11CE); uint256 constant DEADLINE=2_000_000_000;
 function setUpCampaign() internal returns(AssuranceCampaign c){ vm.warp(DEADLINE-100); c=new AssuranceCampaign(2 ether, DEADLINE, ben); vm.deal(alice,10 ether); vm.deal(ben,10 ether); }
 function testPledgeCreditsMsgValue() public { AssuranceCampaign c=setUpCampaign(); vm.prank(alice); c.pledge{value: 1 ether}(); require(c.pledges(alice)==1 ether && c.totalPledged()==1 ether,"credit"); }
 function testLatePledgeReverts() public { AssuranceCampaign c=setUpCampaign(); vm.warp(DEADLINE+1); vm.prank(alice); (bool ok,)=address(c).call{value:1 ether}(abi.encodeCall(c.pledge,())); require(!ok,"late"); }
 function testCollectAndNoDoubleCollect() public { AssuranceCampaign c=setUpCampaign(); vm.prank(alice);c.pledge{value:2 ether}(); vm.warp(DEADLINE+1); vm.prank(ben);c.collect(); require(c.collected(),"collect"); vm.prank(ben);(bool ok,)=address(c).call(abi.encodeCall(c.collect,()));require(!ok,"double"); }
 function testEarlyFinalizeAndRefundFail() public { AssuranceCampaign c=setUpCampaign(); vm.prank(alice);c.pledge{value:1 ether}(); vm.prank(ben);(bool ok,)=address(c).call(abi.encodeCall(c.collect,()));require(!ok,"early collect");vm.prank(alice);(ok,)=address(c).call(abi.encodeCall(c.refund,()));require(!ok,"early refund"); }
 function testRefundAndNoDoubleRefund() public { AssuranceCampaign c=setUpCampaign();vm.prank(alice);c.pledge{value:1 ether}();vm.warp(DEADLINE+1);vm.prank(alice);c.refund();require(c.pledges(alice)==0,"zeroed");vm.prank(alice);(bool ok,)=address(c).call(abi.encodeCall(c.refund,()));require(!ok,"double refund"); }
 function testReentrancyBlocked() public { AssuranceCampaign c=setUpCampaign(); Reenter a=new Reenter(c);vm.deal(address(a),1 ether);a.pledge{value:1 ether}();vm.warp(DEADLINE+1);a.refund();require(c.pledges(address(a))==0,"reenter"); }
 function testBonusProRata() public { AssuranceCampaign c=setUpCampaign();vm.prank(alice);c.pledge{value:1 ether}();vm.prank(ben);c.fundBonus{value:1 ether}();vm.warp(DEADLINE+1);vm.prank(alice);c.refund();require(address(c).balance==0,"bonus paid"); }
}
