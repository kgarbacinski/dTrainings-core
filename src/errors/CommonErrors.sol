// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

library CommonErrors {
    // @notice Thrown when invalid argument provided.
    string public constant INVALID_ARGUMENT = "INVALID_ARGUMENT";

    // @notice Thrown when caller is not authorized to perform action.
    string public constant UNAUTHORIZED_CALLER = "UNAUTHORIZED_CALLER";
}
