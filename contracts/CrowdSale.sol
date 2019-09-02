pragma solidity ^0.5.0;

import "./ZyzCoin.sol";


contract CrowdSale {

	using SafeMath for uint;

	mapping (address => bool) public whiteList;
	mapping (address => uint) public investorAddress;

    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint value, uint amount);

	address private _owner;
    address[] public investors;
    ZyzCoin private _token;

  // The rate is the conversion between wei and the smallest and indivisible token unit.
  uint private _rate;

  // Amount of wei raised
  uint private _weiRaised;
	
	constructor() public{

		_owner = msg.sender;
		_token = new ZyzCoin();
		_rate = 3;
		addToWhiteList(_owner);	   		
	}

    function () external payable {
        buyTokens(msg.sender);
    }

    function token() public view returns (ZyzCoin) {
        return _token;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function rate() public view returns (uint) {
        return _rate;
    }

    function weiRaised() public view returns (uint) {
        return _weiRaised;
    }



	modifier onlyByOwner()
	{

		require (msg.sender == _owner, "sender not authorized");
		_;
	}

	modifier isWitheListed(address _address){ 
		require (whiteList[_address]==true, "not in whiteList"); 
		_; 
	}

	function addToWhiteList(address _address) public onlyByOwner() {
		whiteList[_address] = true;
		investors.push(_address);
	}


function buyTokens(address beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(beneficiary, weiAmount);
    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);
    // update state
    _weiRaised = _weiRaised.add(weiAmount);
    _processPurchase(beneficiary, tokens);
     emit TokensPurchased(
      msg.sender,
      beneficiary,
      weiAmount,
      tokens
    );
  }

//send tokens to investors 
    function airdrop(uint value) public onlyByOwner() {

    	require (_token.balanceOf(msg.sender)> value * investors.length, "cannot process airdrop because of insufficient funds");    	
    	for(uint i=0; i< investors.length; i++)
    	{
    		_token.transferFrom(msg.sender, investors[i], value); 
    	}
    }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  function _preValidatePurchase(
    address beneficiary,
    uint256 weiAmount
  )
    internal pure
  {
    require(beneficiary != address(0));
    require(weiAmount != 0);
  }


  function _deliverTokens(
    address beneficiary,
    uint256 tokenAmount
  )
    internal
  {
    _token.transferFrom(_owner,beneficiary, tokenAmount);
  }

  function _processPurchase(
    address beneficiary,
    uint256 tokenAmount
  )
    internal
  {
    _deliverTokens(beneficiary, tokenAmount);
  }

  function _getTokenAmount(uint256 weiAmount)
    internal view returns (uint256)
  {
    return weiAmount.mul(_rate);
  }



}
