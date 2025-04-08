// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

enum Status { ACTIVE, COMPLETE, IN_PROGRESS, CLOSED }

struct Issue{
    uint issueId;
    string description;
    Status status;
}

contract IssueTracker {

    mapping (uint => Issue) private issuesList;

    function addIssue(uint issueId,string memory description) external {
        issuesList[issueId] = Issue({ issueId: issueId, description: description, status : Status.ACTIVE});
    }

    function updateIssueStatus(uint issueId, string memory status) external {
        bytes32 currentStatus = keccak256(bytes(status));
        bytes32 InProgress = keccak256(bytes("in_progress"));
        bytes32 Complete = keccak256(bytes("complete"));
        bytes32 Closed = keccak256(bytes("closed"));

        if(issuesList[issueId].status == Status.ACTIVE && currentStatus == InProgress)
            issuesList[issueId].status = Status.IN_PROGRESS;
        else if(issuesList[issueId].status == Status.IN_PROGRESS && currentStatus == Complete)
            issuesList[issueId].status = Status.COMPLETE;
        else if(currentStatus == Closed)
            issuesList[issueId].status = Status.CLOSED;
        else
            revert("Invalid status change");
    }

    function getIssueDetails(uint issueId) public view returns (Issue memory) {
        return  issuesList[issueId];
    }
}