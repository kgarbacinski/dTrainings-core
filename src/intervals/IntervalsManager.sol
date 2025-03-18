// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {MultisigAuth} from "auth/MultisigAuth.sol";

/**
    @notice Contract is used to manage intervals.
    Interval is a single period of time during which rewards are calculated and then claimable by users
    who created trainings and won in the rankings.
**/
contract IntervalsManager is MultisigAuth {
    // @dev Start time of the first interval.
    uint256 public immutable genesisTimestamp;

    constructor(address _owner) MultisigAuth(_owner) {}

    function createInterval(uint256 duration) external onlyMultisig {}
}
