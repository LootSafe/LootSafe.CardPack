pragma solidity ^0.4.4;

import "./Token/EIP20Interface.sol";

contract ContentDistributor {
    // Vendor of the content packs
    address vendor;

    mapping(bytes32 => ContentPack) contentPacks;
    bytes32[] contentPackNames;

    // A content pack represents a list of assets to obtain
    struct ContentPack {
        uint256 cost;
        uint256 version;
        bytes32[] assets;
        bool active;
    }

    function ContentDistributor () public {
        vendor = msg.sender;
    }

    // Returns list of available content packs
    function getPacks () external view returns (bytes32[] packs) {
        return contentPackNames;
    }

    // Used to purchase a content pack
    function purchase (bytes32 contentPack) external payable {
        ContentPack memory pack = contentPacks[contentPack];
        // Required sent funds to be equal to cost of pack
        assert(msg.value == pack.cost);

        // Ensure token balance of this contract is enough to distribute card
        for (uint i = 0; i < pack.assets.length; i++) {
            assert(EIP20Interface(pack.assets[i]).balanceOf(this) > 0);
            EIP20Interface(pack.assets[i]).transfer(msg.sender, 1);
        }
    }
}