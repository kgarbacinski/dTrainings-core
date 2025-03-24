// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Proxy} from "src/proxies/Proxy.sol";

abstract contract ManagerProxy is Proxy {
    /// @dev EIP-173 compliant proxy contract inheriting after EIP-1967.

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor(address newImplementation, address owner, bytes memory data) {
        _setImplementation(newImplementation, data);
        _setOwner(owner);
    }

    //////////////////// EXTERNAL FUNCTIONS ////////////////////
    function owner() external view returns (address) {
        return _owner();
    }

    function transferOwnership(address newOwner) external onlyOwner {
        _setOwner(newOwner);
    }

    function upgradeTo(address newImplementation) external onlyOwner {
        _setImplementation(newImplementation, "");
    }

    function upgradeToAndCall(
        address newImplementation,
        bytes calldata data
    ) external payable onlyOwner {
        _setImplementation(newImplementation, data);
    }

    //////////////////// MODIFIERS ////////////////////
    modifier onlyOwner() {
        require(msg.sender == _owner(), "NOT AUTHORIZED");
        _;
    }

    //////////////////// INTERNAL FUNCTIONS ////////////////////
    function _owner() internal view returns (address adminAddress) {
        assembly {
            adminAddress := sload(
                0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103
            )
        }
    }

    function _setOwner(address newOwner) internal {
        require(newOwner != address(0), "New owner is the zero address");

        address previousOwner = _owner();
        assembly {
            sstore(
                0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103,
                newOwner
            )
        }
        emit OwnershipTransferred(previousOwner, newOwner);
    }
}
