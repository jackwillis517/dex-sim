const { ethers, network } = require("hardhat")
const fs = require("fs")

const FRONT_END_ADDRESSES_FILE = "../dex-sim-frontend/constants/contractAddresses.json"
const FRONT_END_ABI_FILE = "../dex-sim-frontend/constants/abi.json"

module.exports = async function () {
    if(process.env.UPDATE_FRONT_END){
        updateContractAddresses()
        updateAbi()
    }
}

async function updateAbi() {
    const dexSim = await ethers.getContract("DexSim")
    fs.writeFileSync(FRONT_END_ABI_FILE, dexSim.interface.format(ethers.utils.FormatTypes.json))
}

async function updateContractAddresses() {
    const dexSim = await ethers.getContract("DexSim")
    const chainId = network.config.chainId.toString()
    const currentAddresses = JSON.parse(fs.readFileSync(FRONT_END_ADDRESSES_FILE, "utf-8"))
    if(chainId in currentAddresses){
        if(!currentAddresses[chainId].includes(dexSim.address)){
            currentAddresses[chainId].push(dexSim.address)
        }
    } else {
        currentAddresses[chainId] = [dexSim.address]
    }
    fs.writeFileSync(FRONT_END_ADDRESSES_FILE, JSON.stringify(currentAddresses))
}

module.exports.tags = ["all", "frontend"]