// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

enum RoleType { ADMIN, USER, INVESTIGATOR }

struct User {
    address userId;
    string name;
    uint NID;
    RoleType role;
}

address constant zeroAddr = 0x0000000000000000000000000000000000000000;

contract UserManager {
    address[] private userList;
    mapping (address => User) private users;

    function registerUser(string memory name, uint nid) public {
        require(findUserByName(name) == zeroAddr, "Name is already taken");
        require(findUserByNID(nid) == zeroAddr, "NID is already taken");
        require(!userExists(msg.sender), "User exists");
        userList.push(msg.sender);
        users[msg.sender] = User({ userId: msg.sender, name: name, NID: nid, role: RoleType.USER });
    }

    function changeRole(address _userId, RoleType role) public {
        require(userExists(_userId), "User does not exist");
        require(users[msg.sender].role == RoleType.ADMIN, "Only Admin can add role");
        users[_userId].role = role;
    }

    function makeAdmin(address _userId) public {
        changeRole(_userId, RoleType.ADMIN);
    }

    function makeInvestigator(address _userId) public {
        changeRole(_userId, RoleType.INVESTIGATOR);
    }

    function normalizeUser(address _userId) public {
        changeRole(_userId, RoleType.USER);
    }

    function findUserByName(string memory _userName) public view returns (address) {
        bytes32 targetUser = keccak256(bytes(_userName));

        for (uint i = 0; i < userList.length; i++)
            if (keccak256(bytes(users[userList[i]].name)) == targetUser) return userList[i];

        return zeroAddr;
    }

    function findUserByNID(uint _nid) public view returns (address) {
        for (uint i = 0; i < userList.length; i++)
            if (users[userList[i]].NID == _nid) return userList[i];

        return zeroAddr;
    }

    function userExists(address _user) public view  returns (bool) {
        for (uint i = 0; i < userList.length; i++)
            if (userList[i] == _user) return true;
        return false;
    }

    function checkUserType(address _user, RoleType _role) public view  returns (bool) {
        for (uint i = 0; i < userList.length; i++)
            if (userList[i] == _user && users[userList[i]].role == _role) return true;
        return false;
    }
}