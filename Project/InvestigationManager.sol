// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { UserManager, User, RoleType } from "./UserManager.sol";
import { ReportManager, Report, ReportStatus } from "./ReportManager.sol";
import { StringUtils } from "./StringUtils.sol";

contract InvestigationManager {
    ReportManager reportManager;
    UserManager userManager;

    constructor(UserManager _userManager, ReportManager _reportManager) {
        reportManager = _reportManager;
        userManager = _userManager;
    }

    
}