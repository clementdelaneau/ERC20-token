const ZyzCoin = artifacts.require('./ZyzCoin.sol');

let tryCatch = require("./exceptions.js").tryCatch;
let errTypes = require("./exceptions.js").errTypes;

contract('Erc20Tests', function (accounts) {

    // Setup before each test
    beforeEach('setup contract for each test', async function () {
        // Deploying contract
        ZyzCoinInstance = await ZyzCoin.new({from: accounts[0]})
    })
	
	it('Test totalSupply', async function () {
		totalSupply = 1
		let result = await ZyzCoinInstance.balanceOf(accounts[0],{from: accounts[0]});
	let balance = await ZyzCoinInstance.balance(accounts[0])
		
		assert.equal(result.toString(), balance.toString())
		
	})
	
	it('Test transfer', async function() {
		let result = await ZyzCoinInstance.transfer(accounts[1],500, {from: accounts[0]});
		let account1Supply = await ZyzCoinInstance.balance(accounts[1])
		assert.equal(account1Supply, 500 )
	})
	
	
})