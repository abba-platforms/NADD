import { ethers } from "hardhat";
import * as dotenv from "dotenv";

dotenv.config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with account:", deployer.address);

  // Deploy NADDToken contract
  const NADDToken = await ethers.getContractFactory("NADDToken");
  const naddToken = await NADDToken.deploy(
    process.env.BENEFICIARY || "",
    process.env.AMOUNT ? ethers.utils.parseUnits(process.env.AMOUNT, 18) : ethers.utils.parseUnits("1", 18),
    process.env.DEPOSIT_REF || "TEST-DEP-001"
  );

  await naddToken.deployed();

  console.log("NADD deployed to:", naddToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
