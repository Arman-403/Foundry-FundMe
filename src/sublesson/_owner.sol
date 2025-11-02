// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract _owner {
    address public contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }

    function privatecall() external view returns (string memory) {
        require(msg.sender == contractOwner, "this is only for OG");
        return ("you are the owner");
    }

    function publiccall() external pure returns (string memory) {
        return ("this is public section");
    }
}
