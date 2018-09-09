pragma solidity ^0.4.24;

    /**
    * Example script for the Ethereum development walkthrough
    */

contract Boxing {
    /**
    * Our boxers
    */
	address public boxer1;
	address public boxer2;

	bool public boxer1Fought;
	bool public boxer2Fought;

	uint private boxer1Deposit;
	uint private boxer2Deposit;

	bool public matchFinished;
    address public theWinner;
    uint gains;

    /**
    * The logs that will be emitted in every step of the contract's life cycle
    */
	event MatchStartsEvent(address boxer1, address boxer2);
	event EndOfRoundEvent(uint boxer1Deposit, uint boxer2Deposit);
	event EndOfWrestlingEvent(address winner, uint gains);

    /**
    * The contract constructor
    */
	constructor() public {
		boxer1 = msg.sender;
	}

    /**
    * A second wrestler can register as an opponent
    */
	function registerAsAnOpponent() public {
        require(boxer2 == address(0));

        boxer2 = msg.sender;
        emit MatchStartsEvent(boxer1, boxer2);
    }

    /**
    * Every round a player can put a sum of ether, if one of the player put in twice or
    * more the money (in total) than the other did, the first wins
    */
    function box() public payable {
    	require(!matchFinished && (msg.sender == boxer1 || msg.sender == boxer2));

    	if(msg.sender == boxer1) {
    		require(boxer1Fought == false);
    		boxer1Fought = true;
    		boxer1Deposit = boxer1Deposit + msg.value;
    	} else {
    		require(boxer2Fought == false);
    		boxer2Fought = true;
    		boxer2Deposit = boxer2Deposit + msg.value;
    	}
    	if(boxer1Fought && boxer2Fought) {
    		if(boxer1Deposit >= boxer2Deposit * 2) {
    			endOfGame(boxer1);
    		} else if (boxer2Deposit >= boxer1Deposit * 2) {
    			endOfGame(boxer2);
    		} else {
                endOfRound();
    		}
    	}
    }

    function endOfRound() internal {
    	boxer1Fought = false;
    	boxer2Fought = false;

    	emit EndOfRoundEvent(boxer1Deposit, boxer2Deposit);
    }

    function endOfGame(address winner) internal {
        matchFinished = true;
        theWinner = winner;

        gains = boxer1Deposit + boxer2Deposit;
        emit EndOfWrestlingEvent(winner, gains);
    }

    /**
    * The withdraw function, following the withdraw pattern shown and explained here:
    * http://solidity.readthedocs.io/en/develop/common-patterns.html#withdrawal-from-contracts
    */
    function withdraw() public {
        require(matchFinished && theWinner == msg.sender);

        uint amount = gains;

        gains = 0;
        msg.sender.transfer(amount);
    }
}