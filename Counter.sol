// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Counter {
    uint public count;

    constructor(uint userCount) {
        count = userCount;
    }

    function increment() public returns (uint) {
        count = count + 1;
        return count;
    }

    function decrease() public returns (uint) {
        require(count > 0, " cannot reduce zero");
        count = count - 1;
        return count;
    }

    function reset() public returns (uint) {
        count = 0;
        return count;
    }
}
