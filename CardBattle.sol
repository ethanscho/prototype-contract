// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract CardBattle {

  struct Unit {
    uint id;
  }

  address private owner;

  Unit[] public units;
  Unit[] private unitsOnSale;

  mapping (uint => Unit) idToUnit;
  mapping (uint => address) public unitToOwner;
  mapping (address => uint) ownerUnitCount;

  constructor() {
    owner = msg.sender;
  }

  function getUnits() external view returns(Unit[] memory) {
    return units;
  }

  function getUnitsOnSale() external view returns(Unit[] memory) {
    return unitsOnSale;
  }

  function getUnitsByOwner(address _owner) external view returns(Unit[] memory) {
    Unit[] memory result = new Unit[](ownerUnitCount[_owner]);
    uint counter = 0;
    for (uint i = 0; i < units.length; i++) {
      if (unitToOwner[units[i].id] == _owner) {
        result[counter] = units[i];
        counter++;
      }
    }
    return result;
  }

  function createUnit(uint id) external {
    Unit memory unit = Unit({id:id});
    units.push(unit);

    unitToOwner[id] = msg.sender;
    ownerUnitCount[msg.sender]++;
    idToUnit[id] = unit;
  }

  function sellUnit(uint id) external {
    require(unitToOwner[id] == msg.sender);
    Unit memory unit = idToUnit[id];
    unitsOnSale.push(unit);
  }

  function greet() view public returns (address) {
    return owner;
  }
}
