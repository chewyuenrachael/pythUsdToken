# 🏦 PythUSDToken – ETH-Powered Dynamic Token Minting with API3 Price Feeds

---

## 📖 Overview

**PythUSDToken** is a smart contract deployed on the **Zircuit Testnet** that allows users to seamlessly **mint and burn ERC20 tokens** based on the **live PYTH/USD price**, fetched via the decentralized oracle network **API3**.

By sending ETH, users mint PUT tokens priced dynamically against the real-world PYTH price. Conversely, users can burn PUT tokens to redeem ETH, maintaining a **real-time, price-pegged experience**.

> This project demonstrates decentralized asset pegging, real-time oracle integration, and secure mint-burn flows on Ethereum-compatible networks.

---

## ✨ Features

| Feature | Description |
|:--------|:------------|
| 🎯 **Dynamic Token Pricing** | Mint and burn tokens based on the real-time PYTH/USD price from an API3 oracle. |
| 🔒 **Slippage Protection** | Specify minimum acceptable tokens when minting to protect against price volatility. |
| 📈 **ETH-to-Token and Token-to-ETH Conversion** | Fully bidirectional: deposit ETH to mint, burn tokens to redeem ETH. |
| 🛡️ **Oracle Integrity Check** | Ensures fetched prices are valid (>0) before allowing any transaction. |
| 🔄 **ERC20 Standard Compliant** | Extends OpenZeppelin’s robust ERC20 implementation for maximum compatibility. |
| 🏛️ **Decentralized Data Feed** | Fetches PYTH/USD prices directly from API3’s serverless, decentralized data sources. |

---

## 🧩 Contract Details

| Item | Description |
|:----|:------------|
| **Name** | `PythUSDToken` |
| **Symbol** | `PUT` |
| **Network** | Zircuit Testnet |
| **Chain ID** | 48899 |
| **Oracles Used** | API3 ServerV1 + Proxy |
| **Hardcoded ETH/USD** | 2400 USD (can be made dynamic) |
| **Decimals** | 18 |

---

## 🏛 Smart Contract Architecture

### 📜 Contract Summary
- Inherits from OpenZeppelin’s `ERC20`.
- Uses the `IProxy` interface from API3 to fetch **live PYTH/USD** pricing.
- Fixed conversion rate of **2400 USD/ETH** used to align ETH input with USD valuations.

### 🧮 Key Functions

| Function | Purpose |
|:---------|:--------|
| `fetchPythPrice()` | Pulls latest PYTH/USD price from the API3 proxy contract. |
| `mintToken(minTokensToMint)` | Users send ETH to mint PUT tokens priced based on the live PYTH/USD feed. |
| `burnToken(amount)` | Users burn PUT tokens and receive ETH calculated by current market price. |

---

## 📜 Full Smart Contract Flow

### Minting PUT Tokens
1. User sends ETH with a call to `mintToken()`.
2. Contract fetches the latest PYTH/USD price via API3.
3. Calculates how many PUT tokens the user should receive.
4. Checks against user's minimum expected tokens to prevent slippage.
5. Mints PUT tokens and assigns them to the user’s wallet.

### Burning PUT Tokens
1. User calls `burnToken()` specifying the number of PUT tokens to burn.
2. Contract fetches the latest PYTH/USD price.
3. Calculates the amount of ETH to return based on the burn amount and live price.
4. Burns the tokens and transfers the corresponding ETH back to the user.

---

## 🔥 Example Calculation

Suppose:

- Fixed `usdPerETH = 2400 * 1e8`
- Fetched `pythPrice = 1000 * 1e8` (PYTH = 1000 USD)

**Mint Scenario**:

```bash
User sends 0.01 ETH
Tokens minted = (0.01 * 2400 * 1e8) / (1000 * 1e8) = 0.024 PUT
```

**Burn Scenario**:

```bash
User burns 0.024 PUT
ETH returned = (0.024 * 1000 * 1e8) / (2400 * 1e8) = 0.01 ETH
```

---

## 🛠️ Installation & Local Deployment

### Prerequisites

- Node.js and npm installed.
- MetaMask or another wallet connected to the **Zircuit Testnet**.
- Funded test ETH wallet.

### Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-repo/pythusdtokens.git
   cd pythusdtokens
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Compile Contracts**
   ```bash
   npx hardhat compile
   ```

4. **Deploy to Zircuit Testnet**
   Customize `deploy.js` to insert the correct proxy address.
   ```bash
   npx hardhat run scripts/deploy.js --network zircuit
   ```

---

## 🖥 Example Interaction via Scripts

### Minting PUT Tokens

```javascript
await contract.mintToken(minTokensExpected, { value: ethers.utils.parseEther("0.01") });
```

### Burning PUT Tokens

```javascript
await contract.burnToken(amountToBurn);
```

---

## 🧠 Potential Improvements

| Area | Enhancement |
|:-----|:------------|
| ⚡ Dynamic USD/ETH Rate | Replace hardcoded 2400 USD/ETH with Chainlink ETH/USD price feeds or API3 ETH/USD proxy. |
| 🧰 Oracle Redundancy | Add multiple oracle fallback mechanisms. |
| 🛡️ Price Staleness Checks | Add timestamp validation to ensure fresh price data. |
| 📜 Events Logging | Emit `Minted` and `Burned` events for easier tracking on-chain. |
| 📊 Frontend Dashboard | Build a React frontend to visualize mint/burn operations and live price feeds. |

---

## 🛠 Technologies Used

- **Solidity 0.8.x**
- **Hardhat** for local development and deployment
- **OpenZeppelin Contracts** (ERC20 base contract)
- **API3 Oracle Services** (ServerV1, Proxy)
- **Ethers.js** for wallet integration and contract interaction

---

## 📚 Documentation and References

- [API3 Docs](https://docs.api3.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Zircuit Testnet Info](https://zircuit.com/)

---

Open to collaboration, optimization suggestions, and extending this project to real-world tokenized assets!
