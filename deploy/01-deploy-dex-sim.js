const { network } = require("hardhat")
const { verify } = require("../utils/verify")
//Contract location on Goereli: 0xF87f86a419DfF17357eF25C0Bd53F028aC6B6E7C

//hre = hardhat runtime enviroment

//Using hardhat-deploy for deployment

//Here instead of passing the hre object as an argument to this async function 
//and calling functions using . we just get the functions from hre with the following syntax

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const dexSim = await deploy("DexSim", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    //If we are deploying to mainnets or testnets we want to verify on Etherscan
    if(network.name != "localhost" && network.name != "hardhat" && process.env.ETHERSCAN_API_KEY){
        await verify(dexSim.address, dexSim.args)
    }

    log("----------------------------------------")
}

module.exports.tags = ["all", "dexSim"]