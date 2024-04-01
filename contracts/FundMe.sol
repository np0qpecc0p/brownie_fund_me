// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"; /**here we import the github code that give us the prices. 
In such way we interact with external data through chainlink oracales **/

// Contract that avaible me to fund into the contract

contract FundMe {
    address[] public funders; //array of funders
    address owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    using SafeMathChainlink for uint256; //safe math prevent from numbes loop when thay reach their max value

    mapping(address => uint256) public addressToAmountFunded;

    // determination of mapping from sender address to sender funded amount (mapping is function that we can call later) function takes the convertion variables types

    function fund() public payable {
        //payable function is function that provides us the ability to pay to contract
        uint256 minUSD = 50 * 10 ** 18;

        require(
            getConversionRate(msg.value) >= minUSD,
            "minimum fund is 50usd - in gwei its"
        );
        addressToAmountFunded[msg.sender] += msg.value; // calling mapping function with msg.sender and msg.value(is this variables determine inside blockchain that provides us to use solidity)
        // what is ETH to USD convertion rate?
        funders.push(msg.sender); //filling the array of funders with funders addresseses
    }

    function getVersion() public view returns (uint256) {
        // function that called interfaces functionality - version
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        // function that called interfaces functionality - latestRound data taking the addres of required convertion rate
        (, int256 answer, , , ) = priceFeed.latestRoundData(); // if all of the returned variables is not used it is posible to not mention them  for better compiling
        return uint256(answer * 10000000000); // converting from int to uint befor return
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        // the function that just do some math using price of our coin from chainlink
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / (10 ** 18);
        return ethAmountInUsd;
    }

    function getEntranceFee() public view returns (uint256) {
        // minimumUSD
        uint256 minimumUSD = 50 * 10 ** 18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10 ** 18;
        return ((minimumUSD * precision) / price);
    }

    modifier OnlyOwner() {
        // modifire is function that will be called befor execution of ever other function that have that modifire
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable OnlyOwner {
        //function that send all the coins at contract to owner of contract

        msg.sender.transfer(address(this).balance); //to request sender send from this contract address al the balance?
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            //loop that reset all fundes to zero
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); // delete funders addresess?
    }
}
