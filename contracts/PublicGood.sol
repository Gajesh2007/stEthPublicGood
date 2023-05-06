// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract PublicGood is Ownable {
    uint256 public depositedAmount;
    mapping(address => uint256) public balances;

    IERC20 public stETH;

    address public donation;
    uint256 public totalDonatedAmmount;

    constructor(
        IERC20 _stETH,
        address _donation
    ) {
        stETH = _stETH;
        donation = _donation;
    }

    function deposit(uint256 _amount) external {
        stETH.transfer(msg.sender, _amount);

        balances[msg.sender] += _amount;
        depositedAmount += _amount;
    }

    function withdraw(uint256 _amount) external {
        balances[msg.sender] -= _amount;
        depositedAmount -= _amount;

        stETH.transfer(msg.sender, _amount);
    }

    function donate() external {
        uint256 amount = stETH.balanceOf(address(this)) - depositedAmount;
        totalDonatedAmmount += amount;
        stETH.transfer(donation, amount);
    }
    
    function changeDonation(address _donation) external onlyOwner {
        donation = _donation;
    }
}
