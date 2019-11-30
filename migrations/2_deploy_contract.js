const ZyzCoin = artifacts.require("./ZyzCoin.sol")
const CrowdSale = artifacts.require("./CrowdSale.sol")

module.exports = function(deployer) {
	deployer.deploy(ZyzCoin);
	deployer.deploy(CrowdSale,ZyzCoin.address);
};