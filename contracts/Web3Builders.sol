// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Kingsx is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 maxSupply = 2000;
    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;

    mapping (address => bool) public allowList;

    constructor(address initialOwner)
        ERC721("Kingsx", "KNX")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmY5rPqGTN1rZxMQg2ApiSZc7JiBNs1ryDzXPZpQhC1ibm/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editMintWindow(bool _publicMintOpen,
        bool _allowListMintOpen)external onlyOwner{
             publicMintOpen = _publicMintOpen;
             allowListMintOpen = _allowListMintOpen;
        }
        

    function allowListMint() public payable {
        require(allowListMintOpen," Allow List Mint Closed!");
        require(allowList[msg.sender], "You are not on the allow list");
        require(msg.value == 0.001 ether, "Not enough funds");
        internalMint();
    }

    function publicMint() public payable {
        require(publicMintOpen, "Public mint has ended");
        require(msg.value == 0.01 ether, "Not enough funds");
        internalMint();
    }

    function setAllowList(address[] calldata addresses)external onlyOwner{
       for (uint256 i = 0; i < addresses.length; i++)
       {
        allowList[addresses[i]] = true;
       }
    }

    function internalMint() internal() {
         require(totalSupply() < maxSupply, "We Sold Out!");
         uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
