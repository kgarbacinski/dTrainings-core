// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IIntervalsManager {
    struct Interval {
        uint256 start;
        uint256 end;
        uint256 duration;
    }

    function createInterval() external returns (uint256);
    function getCurrentIntervalIndex() external view returns (uint256);
    function getCurrentInterval() external view returns (Interval);
}
