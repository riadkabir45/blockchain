// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    string[] public candidates;
    mapping(address => uint) public votes;
    mapping(uint => uint) public candidateVotes;

    function addCandidate(string memory _name) public {
        candidates.push(_name);
    }

    function vote(uint _candidateIndex) public {
        require(_candidateIndex < candidates.length, "Invalid candidate index.");
        require(votes[msg.sender] == 0, "You have already voted.");
        votes[msg.sender] = _candidateIndex + 1;
        candidateVotes[_candidateIndex]++;
    }

    function getVoteCount(uint _candidateIndex) public view returns (uint) {
        require(_candidateIndex < candidates.length, "Invalid candidate index.");
        return candidateVotes[_candidateIndex];
    }

    function getCandidateName(uint _candidateIndex) public view returns (string memory) {
        require(_candidateIndex < candidates.length, "Invalid candidate index.");
        return candidates[_candidateIndex];
    }
}
