// SPDX-License-uuidentifier: MIT
pragma solidity ^0.8.7;

contract CardBattle {

  struct Card {
    uint uuid;
  }

  address private owner;

  Card[] public Cards;
  Card[] private CardsOnSale;

  mapping (uint => Card) uuidToCard;
  mapping (uint => address) public CardToOwner;
  mapping (address => uint) ownerCardCount;

  constructor() {
    owner = msg.sender;
  }

  function getCards() external view returns(Card[] memory) {
    return Cards;
  }

  function getCardsOnSale() external view returns(Card[] memory) {
    return CardsOnSale;
  }

  function getCardsByOwner(address _owner) external view returns(Card[] memory) {
    Card[] memory result = new Card[](ownerCardCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < Cards.length; i++) {
      if (CardToOwner[Cards[i].uuid] == _owner) {
        result[counter] = Cards[i];
        counter++;
      }
    }
    return result;
  }

  function createCard(uint uuid) external {
    Card memory Card = Card({uuid:uuid});
    Cards.push(Card);

    CardToOwner[uuid] = msg.sender;
    ownerCardCount[msg.sender]++;
    uuidToCard[uuid] = Card;
  }

  function sellCard(uint uuid) external {
    require(CardToOwner[uuid] == msg.sender);
    Card memory Card = uuidToCard[uuid];
    CardsOnSale.push(Card);
  }

  function greet() view public returns (address) {
    return owner;
  }
}
