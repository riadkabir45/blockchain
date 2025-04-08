// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IssueTracker, Issue } from './IssueTracker.sol';

contract Driver{
    IssueTracker issueTracker;

    constructor(address _address){
        issueTracker = IssueTracker(_address);
    }

    function addDriverIssue(uint issueId,string memory issueDetails) public {
        issueTracker.addIssue(issueId, issueDetails);
    }

    function updateDriverIssue(uint issueId,string memory status) public {
        issueTracker.updateIssueStatus(issueId, status);
    }

    function getIssue(uint issueId) public view  returns (Issue memory) {
        return issueTracker.getIssueDetails(issueId);
    }
}