// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {MultisigAuth} from "src/auth/MultisigAuth.sol";
import {IIntervalsManager} from "src/intervals/IIntervalsManager.sol";
import {IntervalsErrors} from "src/errors/IntervalsErrors.sol";

/**
    @notice Contract is used to manage intervals.
    Interval is a single period of time during which rewards are calculated and then claimable by users
    who created trainings and won in the rankings.
**/
contract IntervalsManager is IIntervalsManager, MultisigAuth {
    // @dev Start time of the first interval.
    uint256 public immutable genesisTimestamp;
    // @dev Arrray of all intervals.
    Interval[] public intervals;

    constructor(address _owner, uint256 initialDuration) MultisigAuth(_owner) {
        genesisTimestamp = block.timestamp;
        _createInterval(genesisTimestamp, initialDuration);
    }

    function _createInterval(uint256 start, uint256 duration) internal {
        uint256 end = start + duration;
        intervals.push(Interval(start, end, duration));

        emit IntervalCreated(intervals.length - 1, start, end);
    }

    function createInterval(uint256 duration) external override onlyMultisig {
        require(duration > 0, IntervalsErrors.INVALID_DURATION);

        uint256 start = intervals.length == 0
            ? genesisTimestamp
            : intervals[intervals.length - 1].end;
        _createInterval(start, duration);
    }

    function getCurrentIntervalIndex()
        external
        view
        override
        returns (uint256)
    {
        return intervals.length;
    }

    function getCurrentInterval()
        external
        view
        override
        returns (Interval memory)
    {
        return intervals[intervals.length - 1];
    }
}
