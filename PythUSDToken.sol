// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract interacts with the API3 proxy contract to fetch the latest value
import "@api3/contracts/api3-server-v1/proxies/interfaces/IProxy.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PythUSDToken is ERC20 {

    // API3 proxy contract to fetch PYTH price in USD
    address public pythUSDProxy;

    // fixed 2400 USD per ETH (can change this)
    // 8 d.p. for dealing with smaller amounts of ETH
    uint256 public constant usdPerETH = 2400 * 1e8; 

    constructor (address _pythUSDProxy) ERC20 ("PythUSDToken", "PUT") {
        pythUSDProxy = _pythUSDProxy; // PYTH/USD price feed proxy address
    }

    // Function to get the latest PYTH/USD price from the API3 data feed
    function fetchPythPrice() public view returns (uint256) {
        (int224 pythPrice, ) = IProxy(pythUSDProxy).read();
        require(pythPrice > 0, "Invalid PYTH price"); // Checks if the price is valid
        return uint256(int256(pythPrice)); // Converts the int224 price to uint256
    }

    // Function to mint tokens by sending ETH
    function mintToken(uint256 minTokensToMint) external payable {
        uint256 pythPrice = fetchPythPrice(); // Fetch the latest price of PYTH in USD

        // ETH * usdPerETH / usdPerPyth
        uint256 expectedTokens = (msg.value * usdPerETH) / pythPrice; // Calculate no. of tokens to mint

        // Ensure the expected tokens are above the user's minimum acceptable tokens
        require(expectedTokens >= minTokensToMint, "Below minimum expected tokens");

        // mint tokens and assign to user
        _mint(msg.sender, expectedTokens); 
    }

    // Function to burn tokens and receive ETH
    function burnToken(uint256 amount) external {

        // Ensure user has sufficient tokens to burn
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance to burn");

        uint256 pythPrice = fetchPythPrice(); // Get the latest price of PYTH in USD
        uint256 ethToReturn = (amount * pythPrice) / usdPerETH; // Calculate ETH to return

        require(address(this).balance >= ethToReturn, "Contract has insufficient ETH");

        _burn(msg.sender, amount); // Burn the amount of tokens the user specified
        payable(msg.sender).transfer(ethToReturn); // Transfer ETH back to the user
    }
}
