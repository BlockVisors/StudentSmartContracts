pragma solidity ^0.4.19;

contract owned {
    address public owner;
    
    function owned() {
        owner = msg.sender;
        
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner)  onlyOwner {
        owner = newOwner;
    }
}
// we added is owned so that  it inherits the conditions on the owned contract or class
contract SakeCoin is owned {
//public vars
string public name;
string public symbol;
uint8 public decimals;
uint256 public totalSupply;

uint256 public sellPrice;
uint256 public buyPrice;
uint minBalanceForAccounts;




  /* This creates an array with all balance */
mapping (address => uint256) public balanceOf;

mapping (address => bool) public frozenAccount;
event FrozenFunds(address target, bool frozen);

function freezeAccount(address target, bool freeze) onlyOwner public {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
}

// this function iniializes the initial supply
function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) public {
    balanceOf[msg.sender] = initialSupply;
    totalSupply = initialSupply;
    name = tokenName;
    symbol = tokenSymbol;
    decimals = decimalUnits;
    if(centralMinter != 0) owner = centralMinter;
}

// Send coin

/* Internal transfer, can only be called by this contract */
function _transfer(address _from, address _to, uint _value) internal {
  // keep this internal so that it cant be called from just anywhere
  // use require so that it doesn run if
    require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
    require (balanceOf[_from] >= _value);                // Check if the sender has enough
    require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
    require(!frozenAccount[_from]);                     // Check if sender is frozen
   // require(!frozenAccount[_to]);                       // Check if recipient is frozen
    // require(approvedAccount[msg.sender]);            // for whitelist

    balanceOf[_from] -= _value;                         // Subtract from the sender
    balanceOf[_to] += _value;                           // Add the same to the recipient
    Transfer(_from, _to, _value);
    
  
}


function giveBlockReward() {
        balanceOf[block.coinbase] += 1;
    }

    uint currentChallenge = 1; // Can you figure out the cubic root of this number?


function rewardMathGeniuses(uint answerToCurrentReward, uint nextChallenge) {
        require(answerToCurrentReward**3 == currentChallenge); // If answer is wrong do not continue
        balanceOf[msg.sender] += 1;         // Reward the player
        currentChallenge = nextChallenge;   // Set the next challenge
    }

// this is for an owner...he can mint new tokenSymbol
//Just add this to a contract with an owner modifier and you'll be able to create more coins.
function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }


function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
    
    sellPrice = newSellPrice;
    buyPrice = newBuyPrice;
    
}

function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
    }

event Transfer(address indexed from, address indexed to, uint256 value);



}