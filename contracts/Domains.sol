// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import { StringUtils } from "./libraries/StringUtils.sol";
import "hardhat/console.sol";

contract Domains {
  string public tld;

  mapping(string => address) public domains;
  mapping(string => string) public records;

  constructor(string memory _tld) payable {
    tld = _tld;
    console.log("%s domain deployed", tld);
  }

  function price(string calldata name) public pure returns (uint) {
    uint len = StringUtils.strlen(name);
    require(len > 0);

    if (len == 3) {
      return 5 * 10**17; // 0.5 matic for 3 characters
    } else if (len == 4) {
      return 3 * 10**17; // 0.3 matic for 4 characters
    } else {
      return 1 * 10**17; // 0.1 matic for 5+ characters
    }
  }

  function register(string calldata name) public payable {
    require(domains[name] == address(0));

    uint _price = price(name);

    // Check if sender has money for registration
    require(msg.value >= _price, "Not enough matic for domain registration");

    domains[name] = msg.sender;
    console.log("%s has registered a domain %s!", msg.sender, name);
  }

  function getAddress(string calldata name) public view returns (address) {
    return domains[name];
  }

  function setRecord(string calldata name, string calldata record) public {
    require(domains[name] == msg.sender);
    records[name] = record;
  }

  function getRecord(string calldata name) public view returns (string memory) {
    return records[name];
  }
}
