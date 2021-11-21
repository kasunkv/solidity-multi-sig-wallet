// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  // eslint-disable-next-line no-unused-vars
  let addr2: SignerWithAddress;
  // eslint-disable-next-line no-unused-vars
  let addrs: SignerWithAddress[];
  [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

  const wallet = await ethers.getContractFactory("Wallet");
  const walletContract = await wallet.deploy(addr1.address, addr2.address, 2);

  await walletContract.deployed();

  console.log("Greeter deployed to:", walletContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
