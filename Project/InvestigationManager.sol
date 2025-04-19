// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { UserManager, User, RoleType, zeroAddr } from "./UserManager.sol";
import { ReportManager, Report, ReportStatus } from "./ReportManager.sol";
import { StringUtils } from "./StringUtils.sol";

struct InvestigatorInfo {
    address[2] slots;
}

contract InvestigationManager {
    ReportManager reportManager;
    UserManager userManager;
    uint balance;

    mapping (bytes32 => address) investigations;
    mapping (address => address[2]) schedules;

    constructor(UserManager _userManager, ReportManager _reportManager) {
        reportManager = _reportManager;
        userManager = _userManager;
    }

    function assignInvestigator(bytes32 _reportCID, address investigatorAddress) public {
        require(reportManager.checkReportExist(_reportCID), "Report not found");
        require(userManager.checkUserType(investigatorAddress, RoleType.INVESTIGATOR), "To be assigned user is not an investigator");
        require(investigations[_reportCID] == zeroAddr, "Investigator already assigned");
        investigations[_reportCID] = investigatorAddress;
    }

    function getInvestigator(bytes32 _reportCID) public view returns (address) {
        require(investigations[_reportCID] != zeroAddr, "Investigator not assigned");
        return investigations[_reportCID];
    }

    function bookAppointment(bytes32 _reportCID, uint slot) public payable returns (uint) {
        require(slot < 2, "Invalid slot");
        require(msg.value >= 2, "Insifficient funds");
        require(investigations[_reportCID] != zeroAddr, "Investigator not assigned");
        require(schedules[investigations[_reportCID]][slot] == zeroAddr, "Appointment already booked");
        balance += msg.value;
        return msg.value;
    }

    function getInvestigatorAppointment(address _investigator) public view returns (address[2] memory) {
        return schedules[_investigator];
    }


    // function getInvestigatorAppoinment(uint _reportId, uint slot) public view returns (Report memory){
    //     if (slot == 0)
    //         return scheduleOne[getInvestigator(_reportId)];
    //     else
    //         return scheduleTwo[getInvestigator(_reportId)];
    // }

    // function bookAppointment(uint _reportId, uint slot) public payable returns (uint) {
    //     require(msg.value >= 2, "Insifficient funds");
    //     require(investigations[reportManager.findAllReports()[_reportId].cid] != zeroAddr, "Investigator not assigned");
    //     if (slot == 0)
    //         scheduleOne[getInvestigator(_reportId)] = reportManager.findAllReports()[_reportId];
    //     else 
    //         scheduleTwo[getInvestigator(_reportId)] = reportManager.findAllReports()[_reportId];
    //     balance += msg.value;
    //     return msg.value;
    // }

    
}