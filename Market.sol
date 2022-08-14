pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "./IUntitledERC721.sol";

contract Market is Ownable {
    /* The address of ERC721 token contract */
    address public erc721ContractAddress = address(0);
    uint public fee = 250; // 2.50%
    uint256 public minPrice = 0.0001 ether; 

    struct Sale {
        uint tokenId;
        uint256 price;
        address payable seller;
    }

    mapping(uint => Sale) private sales;

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

    function setFee(uint value) external onlyOwner {
        fee = value;
    }

    function sell(uint tokenId, uint price) external {
        IUntitledERC721 erc721 = IUntitledERC721(erc721ContractAddress);

        require(erc721.ownerOf(tokenId) == msg.sender, "Sender does not own this card.");
        require(price >= minPrice, "Price is too low");
        require(sales[tokenId].tokenId == 0, "Token is already on sale.");

        Sale memory sale = Sale({
            tokenId: tokenId,
            price: price,
            seller: payable(msg.sender)
        });
        sales[tokenId] = (sale);
    } 

    function cancel(uint tokenId) external {
        IUntitledERC721 erc721 = IUntitledERC721(erc721ContractAddress);
        
        require(erc721.ownerOf(tokenId) == msg.sender, "Sender does not own this card.");
        require(sales[tokenId].tokenId > 0, "Token is not on sale.");

        delete sales[tokenId];
    }

    function buy(uint tokenId) external payable {
        IUntitledERC721 erc721 = IUntitledERC721(erc721ContractAddress);

        require(erc721.ownerOf(tokenId) == sales[tokenId].seller, "Seller does not own this card.");
        require(sales[tokenId].tokenId > 0, "Token is not on sale.");
        require(msg.value >= sales[tokenId].price, "The sent amount is not enough.");

        // transfer ether to seller
        uint256 txFee = SafeMath.mul(sales[tokenId].price, fee) / 10000;
        uint256 profit = SafeMath.sub(sales[tokenId].price, txFee);
        sales[tokenId].seller.transfer(profit);

        // transfer ERC721 token
        erc721.safeTransferFrom(
            sales[tokenId].seller,
            msg.sender,
            tokenId
        );

        // delete from sales record
        delete sales[tokenId];
    }

    function getSale(uint tokenId) external view returns(Sale memory) {
        return sales[tokenId];
    }
}