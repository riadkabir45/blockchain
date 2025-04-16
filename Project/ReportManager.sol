// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { UserManager, User, RoleType } from "./UserManager.sol";
import { StringUtils } from "./StringUtils.sol";

enum ReportStatus { MISSING, FOUND, FALSE }

enum Urgency { NORMAL, HIGH, CRITICAL }

struct Report {
    bytes32 cid;
    string name;
    uint age;
    uint height;
    string description;
    string location;
    string contact;
    Urgency urgency;
    ReportStatus status;
}

contract ReportManager {
    using StringUtils for string;

    Report[] reports;
    UserManager userManager;

    mapping (bytes32 => address) public investigations;

    string[] divisions = [
        "dhaka",
        "chattogram",
        "rajshahi",
        "khulna",
        "barishal",
        "sylhet",
        "rangpur",
        "mymensingh"
    ];

    constructor(address _userManager) {
        userManager = UserManager(_userManager);
    }

    function checkDivision(string memory _location) public view returns (string memory) {
        string memory cleanLocation = _location.toLower();
        for (uint i = 0; i < divisions.length; i++){
            if (cleanLocation.compare(divisions[i])) return divisions[i];
        }
        return "NIL";
    }

    function reportMissing(string memory _name, uint256 _age, uint256 _height,string memory _description, string memory _location, string memory _contact) public returns (uint) {
        require(userManager.userExists(msg.sender), "User does not exist");
        require(userManager.checkUserType(msg.sender, RoleType.REPORTER), "Not a reporter");
        require(!checkDivision(_location).compare("NIL"), "Division does not exist");

        bytes32 cid = keccak256( abi.encodePacked(msg.sender, _name, _description, _location, _contact));
        Urgency urgency = Urgency.NORMAL;

        if (_age < 18)
            urgency = Urgency.CRITICAL;
        else if (_height < 50)
            urgency = Urgency.HIGH;

        reports.push(Report(cid, _name, _age, _height, _description, _location, _contact, urgency, ReportStatus.MISSING));
        return reports.length - 1;
    }

    function updateReport(uint _reportId, ReportStatus status) public {
        require(userManager.checkUserType(msg.sender, RoleType.REPORTER), "Access denied");
        require(_reportId < reports.length, "Invalid id");
        require(reports[_reportId].status == ReportStatus.MISSING, "Report already found or reported false.");
        reports[_reportId].status = status;
    }

    function reportComplete(uint _reportId) public {
        updateReport(_reportId, ReportStatus.FOUND);
    }

    function reportFalse(uint _reportId) public {
        updateReport(_reportId, ReportStatus.FALSE);
    }

    function assignInvestigator(uint _reportId, address investigatorAddress) public {
        investigations[reports[_reportId].cid] = investigatorAddress;
    }

    function sortDivisionByCount() public {
        
    }

    function findReportByDivision(string memory _location) public view returns (Report[] memory)  {
        uint filterCount = 0;
        for (uint i = 0; i < reports.length; i++) 
            if (reports[i].location.compare(_location))
                filterCount++;

        Report[] memory filters = new Report[](filterCount);
        filterCount = 0;
        for (uint i = 0; i < reports.length; i++)
            if(reports[i].location.compare(_location)) {
                filters[filterCount]  = reports[i];
                filterCount++;
            }
        
        return filters;
    }
}