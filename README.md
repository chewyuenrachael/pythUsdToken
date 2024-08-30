### PythUSDToken Project

---

## **Project Overview**

The **PythUSDToken** project is a Solidity-based smart contract deployed on the Zircuit testnet. This project leverages the API3 decentralized oracle network to fetch the real-time price of the PYTH/USD pair and allows users to mint and burn Pyth tokens by interacting with the contract using ETH. 

This contract provides a mechanism for users to mint new tokens by sending ETH and burn their tokens to redeem ETH. The value of the tokens is dynamically calculated based on the latest price data fetched from the API3 PYTH/USD data feed.

---

## **Features**

1. **Minting PythUSD Tokens**: Users can mint PythUSD tokens by sending ETH to the contract. The number of tokens minted is determined by the current exchange rate between PYTH and USD, as provided by the API3 data feed.

2. **Burning PythUSD Tokens**: Users can burn their PythUSD tokens to redeem ETH. The amount of ETH returned is calculated based on the current PYTH/USD price.

3. **Real-time Price Fetching**: The contract fetches the latest PYTH/USD price from the API3 data feed, ensuring that the token minting and burning operations reflect the most accurate market data.

4. **Slippage Protection**: During minting, users can specify a minimum number of tokens they expect to receive, preventing transactions from proceeding if the price fluctuates too much.

---

## **Smart Contract Details**

### **Contract Structure**

- **`PythUSDToken` Contract**: An ERC20 token contract that interacts with the API3 data feed to enable minting and burning of tokens based on the latest PYTH/USD price.

### **Code Explanation**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing API3 proxy interface to fetch the latest value of PYTH/USD
import "@api3/contracts/api3-server-v1/proxies/interfaces/IProxy.sol";
// Importing OpenZeppelin ERC20 implementation for standard token functionalities
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PythUSDToken is ERC20 {

    // Address of the API3 proxy contract used to fetch PYTH/USD price
    address public pythUSDProxy;

    // Fixed exchange rate of 2400 USD per ETH, with 8 decimal places for precision
    uint256 public constant usdPerETH = 2400 * 1e8; 

    // Constructor to initialize the proxy address and set the token details
    constructor (address _pythUSDProxy) ERC20("PythUSDToken", "PUT") {
        pythUSDProxy = _pythUSDProxy; // Assign the proxy address for fetching PYTH/USD price
    }

    // Function to fetch the latest PYTH/USD price from the API3 data feed
    function fetchPythPrice() public view returns (uint256) {
        (int224 pythPrice, ) = IProxy(pythUSDProxy).read(); // Read the price from the proxy
        require(pythPrice > 0, "Invalid PYTH price"); // Ensure the fetched price is valid
        return uint256(int256(pythPrice)); // Convert the price to uint256 for use in calculations
    }

    // Function to mint tokens by sending ETH
    function mintToken(uint256 minTokensToMint) external payable {
        uint256 pythPrice = fetchPythPrice(); // Fetch the latest PYTH/USD price

        // Calculate the number of tokens to mint based on ETH sent, fixed USD/ETH rate, and PYTH/USD price
        uint256 expectedTokens = (msg.value * usdPerETH) / pythPrice; 

        // Ensure the number of tokens to be minted meets or exceeds the user's minimum expectation
        require(expectedTokens >= minTokensToMint, "Below minimum expected tokens");

        _mint(msg.sender, expectedTokens); // Mint the tokens and assign them to the user
    }

    // Function to burn tokens and receive ETH
    function burnToken(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance to burn"); // Ensure the user has enough tokens to burn

        uint256 pythPrice = fetchPythPrice(); // Get the latest PYTH/USD price
        uint256 ethToReturn = (amount * pythPrice) / usdPerETH; // Calculate the amount of ETH to return

        require(address(this).balance >= ethToReturn, "Contract has insufficient ETH"); // Ensure the contract has enough ETH to fulfill the request

        _burn(msg.sender, amount); // Burn the specified amount of tokens
        payable(msg.sender).transfer(ethToReturn); // Transfer the corresponding amount of ETH back to the user
    }
}
```

### **Key Components**

- **`pythUSDProxy`**: Stores the address of the API3 proxy contract that provides the latest PYTH/USD price.
  
- **`usdPerETH`**: A constant representing the fixed exchange rate of 2400 USD per ETH, used for calculating token minting and burning.

- **`fetchPythPrice()`**: A function that interacts with the API3 proxy contract to get the latest PYTH/USD price.

- **`mintToken()`**: Allows users to mint PythUSD tokens by sending ETH, with the amount of tokens calculated based on the current exchange rates.

- **`burnToken()`**: Allows users to burn their PythUSD tokens to redeem ETH, calculated using the latest PYTH/USD price.

---

## **Deployment Details**

- **Network**: Zircuit Testnet
- **Chain ID**: 48899
- **Contracts Deployed**:
  - `Api3ServerV1.sol`: `0x55Cf1079a115029a879ec3A11Ba5D453272eb61D`
  - `ProxyFactory.sol`: `0x1DCE40DC2AfA7131C4838c8BFf635ae9d198d1cE`

---

## **Setup and Deployment**

### **Prerequisites**

- Node.js and npm installed on your system.
- A wallet with some test ETH on the Zircuit Testnet.
- Access to the API3 Market for obtaining proxy addresses.

### **Steps to Deploy**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/pyth-usd-token.git
   cd pyth-usd-token
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Compile the Contract**:
   ```bash
   npx hardhat compile
   ```

4. **Deploy the Contract**:
   Update the deployment script with your specific proxy address from the API3 Market, then run:
   ```bash
   npx hardhat run scripts/deploy.js --network zircuit
   ```

5. **Verify Deployment**:
   Verify the deployed contract on the Zircuit Testnet explorer.

---

## **How to Use the Contract**

1. **Minting Tokens**:
   - Call the `mintToken()` function from a wallet interface or via a web3 client, sending the desired amount of ETH. Ensure to specify the minimum number of tokens you expect to receive.

2. **Burning Tokens**:
   - Call the `burnToken()` function, specifying the amount of tokens you wish to burn. The corresponding amount of ETH will be returned to your address.

---

## **Potential Improvements and Considerations**

- **Dynamic USD/ETH Rate**: Currently, the contract uses a hardcoded USD/ETH rate. Integrating a live data feed for USD/ETH from API3 or another oracle provider could enhance accuracy.

- **Fallback Oracle**: Introduce a fallback mechanism in case the primary oracle fails to provide data.

---

## **FAQ**

### **1. What is PythUSDToken?**
PythUSDToken is an ERC20 token that allows users to mint and burn tokens using ETH, with the value of the tokens tied to the real-time PYTH/USD price fetched from an API3 data feed.

### **2. How is the token value determined?**
The value is determined by the amount of ETH sent by the user, the fixed USD/ETH exchange rate (currently 2400 USD/ETH), and the real-time PYTH/USD price provided by the API3 data feed.

### **3. Can the USD/ETH rate be changed?**
Yes, the contract currently uses a hardcoded value, but it can be updated to fetch live data from an oracle.

### **4. Is there a maximum supply of tokens?**
Currently, there is no cap on the total supply of tokens. However, a cap can be introduced if needed.
