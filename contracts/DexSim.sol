// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract DexSim {
    address _user; 
    mapping(string => uint256) public liquidityPool;
    mapping(address => mapping(string => uint256)) public balance;  

    constructor() {
        liquidityPool["Buterins"] = 6;
        liquidityPool["Nakamotos"] = 2;
    }
  
    function calculateReturn(int amount, string memory tokenTrading) public view returns (int){
        int tradeReturn;
        uint bLiquidity = liquidityPool["Buterins"];
        uint nLiquidity = liquidityPool["Nakamotos"];
        int buterinsLiquidity = int(bLiquidity);
        int nakamotosLiquidity = int(nLiquidity);

        if(keccak256(abi.encodePacked(tokenTrading)) == keccak256(abi.encodePacked("Nakamotos"))) {
            tradeReturn = -1 * (((buterinsLiquidity * nakamotosLiquidity) - ((nakamotosLiquidity + amount) * buterinsLiquidity)) 
                     / (nakamotosLiquidity + amount));
        } else {
            tradeReturn = -1 * (((buterinsLiquidity * nakamotosLiquidity) - ((buterinsLiquidity + amount) * nakamotosLiquidity)) 
                     / (buterinsLiquidity + amount));
        }

        return tradeReturn;
    }

    function swapButerins(int amount) public returns (int){
        int tradeReturn;
        require( balance[_user]["Buterins"] >= uint(amount), "Not enough funds!");
        tradeReturn = calculateReturn(amount, "Buterins");
        balance[_user]["Buterins"] -= uint(amount);
        balance[_user]["Nakamotos"] += uint(tradeReturn);
        liquidityPool["Buterins"] += uint(amount);
        liquidityPool["Nakamotos"] -= uint(tradeReturn);
        return tradeReturn;
    }

    function swapNakamotos(int amount) public returns (int){
        int tradeReturn;
        require(balance[_user]["Nakamotos"] >= uint(amount), "Not enough funds!");
        tradeReturn = calculateReturn(amount, "Nakamotos");
        balance[_user]["Nakamotos"] -= uint(amount);
        balance[_user]["Buterins"] += uint(tradeReturn);
        liquidityPool["Nakamotos"] += uint(amount);
        liquidityPool["Buterins"] -= uint(tradeReturn);
        return tradeReturn;
    }

    function reset() public {
        liquidityPool["Buterins"] = 6;
        liquidityPool["Nakamotos"] = 2;
        balance[_user]["Buterins"] = 10;
        balance[_user]["Nakamotos"] = 10;
    }

    function addLiquidity(uint256 amountNakamotos, uint256 amountButerins) public {
        liquidityPool["Nakamotos"] += amountNakamotos;
        liquidityPool["Buterins"] += amountButerins;
    }

    function addUser() public {
        _user = msg.sender;
        balance[_user]["Buterins"] = 10;
        balance[_user]["Nakamotos"] = 10;
    }

    function addButerinsToUser(uint256 amount) public {
        balance[_user]["Buterins"] += amount;
    }

    function addNakamotosToUser(uint256 amount) public {
        balance[_user]["Nakamotos"] += amount;
    }

    function getUserButerinBalance() public view returns(uint256){
        return balance[_user]["Buterins"];
    }

    function getUserNakamotosBalance() public view returns(uint256){
        return balance[_user]["Nakamotos"];
    }

    function getButerins() external view returns (uint256){
        return liquidityPool["Buterins"];
    }

    function getNakamotos() external view returns (uint256){
        return liquidityPool["Nakamotos"];
    }
}