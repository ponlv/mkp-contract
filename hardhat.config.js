require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },  
  networks: {
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: process.env.PRIVATE_KEY_TESTNET !== undefined
      ? [process.env.PRIVATE_KEY_TESTNET]
      : [],
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com/",
      accounts: process.env.PRIVATE_KEY_TESTNET !== undefined
      ? [process.env.PRIVATE_KEY_TESTNET]
      : [],
    },
    bsc: {
      url: "https://bsc-dataseed.binance.org/",
      accounts: process.env.PRIVATE_KEY !== undefined
      ? [process.env.PRIVATE_KEY]
      : [],
    }

  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: "7FK5NBT2XFJ1CJSTWH8I8WDR9MF1KYNNUH",
  },
  allowUnlimitedContractSize: true
};