# Foundry FundMe

A crowdfunding smart contract built with Foundry that allows users to send ETH, tracks contributors, and enables only the owner to withdraw funds. This project demonstrates professional smart contract development practices including deployment scripts, comprehensive testing, and gas optimization.

## Features

- **Fund Contract**: Send ETH to the contract with a minimum USD value requirement
- **Price Conversion**: Uses Chainlink Price Feeds to convert ETH to USD
- **Owner Withdrawals**: Only the contract owner can withdraw all funds
- **Contributor Tracking**: Maintains a record of all funders and their contributions
- **Gas Optimized**: Implements storage patterns and optimization techniques
- **Comprehensive Testing**: Unit and integration tests with Foundry

## Built With

- [Foundry](https://book.getfoundry.sh/) - Ethereum development toolkit
- [Solidity](https://soliditylang.org/) - Smart contract programming language
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds/price-feeds) - Real-time ETH/USD price data

## Prerequisites

- [Git](https://git-scm.com/)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Arman-403/Foundry-FundMe.git
cd Foundry-FundMe
```

2. Install dependencies:
```bash
forge install
```

3. Build the project:
```bash
forge build
```

## Usage

### Running Tests

Run all tests:
```bash
forge test
```

Run tests with verbosity:
```bash
forge test -vvv
```

Run specific test:
```bash
forge test --match-test testFunctionName
```

### Test Coverage

Check test coverage:
```bash
forge coverage
```

### Deployment

Deploy to Anvil (local):
```bash
make deploy-anvil
```

Deploy to Sepolia testnet:
```bash
make deploy-sepolia
```
## Project Structure

```
Foundry-FundMe/
├── src/
│   ├── FundMe.sol              # Main contract
│   └── PriceConverter.sol      # Price conversion library
├── script/
│   ├── DeployFundMe.s.sol      # Deployment script
│   ├── HelperConfig.s.sol      # Network configuration
│   └── Interactions.s.sol      # Interaction scripts
├── test/
│   ├── unit/                   # Unit tests
│   └── integration/            # Integration tests
├── lib/                        # Dependencies
├── Makefile                    # Build automation
└── foundry.toml                # Foundry configuration
```

## Key Concepts Learned

- **Foundry Framework**: Project setup, testing, and deployment workflows
- **Smart Contract Development**: Building production-ready contracts
- **Testing Strategies**: Unit tests, integration tests, and forking tests
- **Gas Optimization**: Storage patterns and efficiency improvements
- **Helper Configs**: Multi-network deployment configurations
- **Makefiles**: Workflow automation for common tasks
- **Chainlink Integration**: Working with external price feed oracles

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Built following the Cyfrin Updraft Foundry course
- Uses Chainlink's decentralized oracle network
- Inspired by the Web3 development community

## Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [Chainlink Documentation](https://docs.chain.link/)
- [Solidity Documentation](https://docs.soliditylang.org/)

---

Made with ❤️ by Arman