const hre = require("hardhat");

async function main() {
  const TOKEN_ADDRESS = "0x..."; // Your deployed ERC20 token
  const BENEFICIARY = "0x...";   // Wallet to receive tokens

  const Vesting = await hre.ethers.getContractFactory("TokenVesting");
  const vesting = await Vesting.deploy(TOKEN_ADDRESS);
  await vesting.waitForDeployment();

  const startTime = Math.floor(Date.now() / 1000);
  const cliff = 31536000; // 1 year in seconds
  const duration = 126144000; // 4 years in seconds
  const amount = hre.ethers.parseUnits("100000", 18);

  await vesting.createSchedule(BENEFICIARY, startTime, cliff, duration, amount);

  console.log("Vesting Contract:", await vesting.getAddress());
  console.log("Schedule created for:", BENEFICIARY);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
