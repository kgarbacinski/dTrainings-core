// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {CommonErrors} from "errors/Common.sol";

abstract contract Auth {
    // @dev Emitted when new owner address is set.
    event OwnerSet(address oldOwner, address newOwner);

    // @dev Emitted when ownership transfer is initiated.
    /// @param previousOwner Old multisig, one that initiated the process.
    /// @param newOwner New multisig, one that should finalize the process.
    event OwnershipTransferStarted(
        address indexed previousOwner,
        address indexed newOwner
    );

    // @dev Current owner of contracts.
    address public owner;

    // @dev Pending address of owner used for the ownership transfer.
    address public pendingOwner;

    constructor(address _owner) {
        require(_owner != address(0), CommonErrors.INVALID_ARGUMENT);
        owner = _owner;

        emit OwnerSet(address(0), owner);
    }

    // @dev Starts the ownership transfer of the contract to a new account. Can be called by the current owner only.
    function transferOwnership(address newOwner) external {
        require(newOwner != address(0), CommonErrors.INVALID_ARGUMENT);
        require(msg.sender == owner, CommonErrors.UNAUTHORIZED_CALLER);

        owner = newOwner;

        emit OwnershipTransferStarted(owner, pendingOwner);
    }

    // @dev Accepts the ownership transfer of the contract to a new account. Can be called by the pending owner only.
    function acceptOwnership() external {
        require(msg.sender == pendingOwner, CommonErrors.UNAUTHORIZED_CALLER);
        address oldOwner = owner;

        owner = pendingOwner;
        pendingOwner = address(0);

        emit OwnerSet(oldOwner, owner);
    }
}
