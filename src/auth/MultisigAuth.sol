// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Auth} from "src/auth/Auth.sol";
import {CommonErrors} from "src/errors/CommonErrors.sol";

abstract contract MultisigAuth is Auth {
    constructor(address _multisig) Auth(_multisig) {}

    modifier onlyMultisig() {
        require(msg.sender == owner, CommonErrors.UNAUTHORIZED_CALLER);
        _;
    }

    function getMultisig() external view returns (address) {
        return owner;
    }
}
