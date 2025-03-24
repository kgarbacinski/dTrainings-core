// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Proxy} from "src/proxies/Proxy.sol";
import {ManagerProxy} from "src/proxies/ManagerProxy.sol";

contract IntervalsManagerProxy is ManagerProxy {
    constructor(
        address newImplementation,
        address owner,
        bytes memory data
    ) ManagerProxy(newImplementation, owner, data) {}
}
