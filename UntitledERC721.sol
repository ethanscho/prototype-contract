pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract UntitledERC721 is ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _counter;

    constructor() ERC721("Untitled Project", "UPT") {

    }

    function mint(uint256 tokenId, string memory tokenURI) external onlyOwner {
        _counter.increment();
        require(tokenId == _counter.current());
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function getCount() external view returns (uint256) {
        return _counter.current();
    }

    function setTokenURI(uint256 tokenId, string memory tokenURI) external onlyOwner {
        _setTokenURI(tokenId, tokenURI);
    }
}