pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "./IUntitledERC721.sol";

contract Game is Ownable {
    /* The address of ERC721 token contract */
    address public erc721ContractAddress = address(0);

    function getBalance() external view returns (uint256){
        return address(this).balance;
    }

    function withdraw() external onlyOwner() {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setERC721ContractAddress(address value) external onlyOwner {
        require(value != address(0), "Contract address cannot be null.");
        erc721ContractAddress = value;
    }

    function merge(uint tokenId1, uint tokenId2) external {
        IUntitledERC721 erc721 = IUntitledERC721(erc721ContractAddress);

        require(erc721.ownerOf(tokenId1) == msg.sender, "Sender does not own the first card.");
        require(erc721.ownerOf(tokenId2) == msg.sender, "Sender does not own the second card.");
        
        erc721.burn(tokenId1);
    } 
}