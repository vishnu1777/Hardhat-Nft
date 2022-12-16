const { network, ethers } = require("hardhat");
const { developmentChains } = require("../helper-hardhat-config");
/* this base is the premium row of 0.25 base price in contact address:documentation Chainlink */
/* You can refer here: https://docs.chain.link/vrf/v2/subscription/supported-networks/#configurations*/
const DECIMALS = "18";
const INITIAL_PRICE = ethers.utils.parseEther("2000", "ether");

const BASE_FEE = "250000000000000000";
const GAS_PRICE_LINK = 1e9;
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const args = [BASE_FEE, GAS_PRICE_LINK];

  // If we are on a local development network, we need to deploy mocks!
  //if (chainId == 31337) {
  if (developmentChains.includes(network.name)) {
    log("Local network detected! Deploying mocks...");
    await deploy("VRFCoordinatorV2Mock", {
      contract: "VRFCoordinatorV2Mock",
      from: deployer,
      log: true,
      args: args,
    });
    await deploy("MockV3Aggregator", {
      from: deployer,
      log: true,
      args: [DECIMALS, INITIAL_PRICE],
    });
    log("Mocks Deployed!");
    log("------------------------------------------------");
  }
};
module.exports.tags = ["all", "mocks"];
