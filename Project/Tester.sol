// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { StringUtils } from './StringUtils.sol';

contract Tester{
    using StringUtils for string;
    
    function test() public pure returns (bool) {
        string memory t1 = "wtf";
        string memory t2 = "wTf";
        return keccak256(bytes(t1.toLower())) == keccak256(bytes(t2.toLower()));
    }
}