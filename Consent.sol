// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Consent {
    struct ConsentRecord {
        address user;
        string dataType;
        address recipient;
        string ipfsHash;
    }

    mapping (address => mapping (string => mapping (address => ConsentRecord))) consents;

    function giveConsent(address user, string memory dataType, address recipient, string memory ipfsHash) public {
        require(msg.sender == user, "Only the owner of the file can give consent.");
        consents[user][dataType][recipient] = ConsentRecord(user, dataType, recipient, ipfsHash);
    }

    function revokeConsent(address user, string memory dataType, address recipient) public {
        require(msg.sender == user, "Only the owner of the file can revoke consent.");
        delete consents[user][dataType][recipient];
    }

    function checkConsent(address user, string memory dataType, address recipient) public view returns (bool) {
        return consents[user][dataType][recipient].recipient != address(0);
    }

    function getIpfsHash(address user, string memory dataType, address recipient) public view returns (string memory) {
        require(checkConsent(user, dataType, recipient) == true, "The recipent dosent have the access to this file!");
        require(msg.sender == recipient, "Only the recipient can access the IPFS hash.");
        return consents[user][dataType][recipient].ipfsHash;
    }
}