pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract TradableCardBattle is ERC721URIStorage, Ownable {

    constructor() ERC721("TradableCardBattle", "TCG") {

    }

    function mint(uint256 tokenId, string memory tokenURI) public onlyOwner {
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
}