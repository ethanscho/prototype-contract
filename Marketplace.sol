pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "./IUntitledERC721.sol";

contract Marketplace is Ownable {
    address public erc721ContractAddress = address(0);
    uint public marketplaceFee = 250;
    uint public minPrice = 10000;

    struct Sale {
        uint tokenId;
        uint price;
        address seller;
    }

    Sale[] private sales;

    function setERC721ContractAddress(address value) external onlyOwner {
        require(value != address(0), "Contract address cannot be null.");
        erc721ContractAddress = value;
    }

    function sellCard(uint tokenId, uint price) external {
        IUntitledERC721 erc721 = IUntitledERC721(erc721ContractAddress);

        require(erc721.ownerOf(tokenId) == msg.sender, "Sender does not own this card.");
        require(price >= minPrice, "Price is too low");

        Sale memory sale = Sale({
            tokenId: tokenId,
            price: price,
            seller: msg.sender
        });
        sales.push(sale);
    } 

    function getSales() external view returns(Sale[] memory) {
        return sales;
    }
}