	pragma solidity 0.4.19;

	import "./AuctionInterface.sol";

	/** @title GoodAuction */
	contract GoodAuction is AuctionInterface {

		mapping(address => uint) refunds;

		function bid() payable external returns(bool) {
			if(msg.value > highestBid) {
				refunds[highestBidder] = highestBid;
				highestBidder = msg.sender;
				highestBid = msg.value;
				return true;	
			} else {
				refunds[msg.sender] = msg.value;
				return false;
			}
		}

		function withdrawRefund() external returns(bool) {
			uint amount = refunds[msg.sender];

			require(amount > 0);

			if(msg.sender.send(amount)) {
				delete refunds[msg.sender];
				return true;
			} else {
				refunds[msg.sender] = amount;
				return false;
			}
			
		}

		function getMyBalance() constant external returns(uint) {
			return refunds[msg.sender];
		}


		// Why this one throws VM error?
		// modifier canReduce() {
		// 	require(msg.sender == highestBidder);
		//  _;
		// }

		modifier canReduce() {
			if(msg.sender == highestBidder) {
				_;
			}

		}

		function reduceBid() external canReduce {
			if (highestBid >= 0) {
				require(highestBid-1 > 0);
	     	highestBid = highestBid - 1;
	     	require(highestBidder.send(1));
	    } else {
	    	revert();
	    }
		}

		function () payable {
			// YOUR CODE HERE <- What here?
		}

	}
