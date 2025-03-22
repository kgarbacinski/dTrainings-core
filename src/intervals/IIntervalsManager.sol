// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

abstract contract IIntervalsManager {
    struct Interval {
        uint256 start;
        uint256 end;
        uint256 duration;
    }

    event IntervalCreated(
        uint256 indexed intervalIndex,
        uint256 start,
        uint256 end
    );

    function createInterval(uint256 duration) external virtual;
    function getCurrentIntervalIndex() external view virtual returns (uint256);
    function getCurrentInterval()
        external
        view
        virtual
        returns (Interval memory);
}
