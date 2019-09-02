pragma solidity ^0.5.0;


import "./SafeMath.sol";


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// ----------------------------------------------------------------------------
contract ZyzCoinInterface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and a
// fixed supply
// ----------------------------------------------------------------------------
contract ZyzCoin is ZyzCoinInterface, Owned
{
	using SafeMath for uint;

     mapping(address => uint256) public balance;
     // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping (address => uint)) allowed;


    bytes32 public symbol;
    bytes32 public  name;
    uint8 public decimals;
    uint _totalSupply;

     constructor() public {
        symbol = "ZYZ";
        name = "ZyzCoin";
        decimals = 18;
        _totalSupply = 1000000 * 10**uint(decimals);
        balance[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }




    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balance[address(0)]);
    }

   function balanceOf(address _tokenOwner) public view returns (uint256) {
   	return balance[_tokenOwner];
   }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
   function allowance(address _tokenOwner, address _spender) public view returns (uint) {
   	return allowed[_tokenOwner][_spender];

   }


   function transfer(address _to, uint _tokens) public returns ( bool success) {

   	require (balance[msg.sender] >= _tokens);
   	balance[msg.sender] -=  _tokens;
   	balance[_to] += _tokens;
   	emit Transfer(msg.sender, _to, _tokens);
   	return true;
   }


   function approve(address _spender, uint _tokens) public returns (bool) {
   	allowed[msg.sender][_spender] = _tokens;
   	emit Approval(msg.sender, _spender, _tokens);
   	return true;
   }


   function transferFrom(address _from, address _to, uint _tokens) public returns (bool) {

   	require (balance[_from]>= _tokens);
   	require (allowed[_from][msg.sender]>= _tokens);
   	balance[_from] -= _tokens;
   	allowed[_from][msg.sender] -= _tokens;
   	balance[_to] += _tokens;
   	emit Transfer(_from, _to, _tokens);
   	return true;
   	
   }

}

  