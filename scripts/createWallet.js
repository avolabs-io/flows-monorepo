const { ethers } = require("ethers");
const fs = require("fs");
const editDotenv = require("edit-dotenv");

const envfilePath = "../.env";

/**
 * Function to add fields to users env file
 * @param {String} key
 * @param {String} value
 */
const updateEnvFile = (key, value) => {
  if (!fs.existsSync(envfilePath)) {
    // env file doesn't exist so create it.
    fs.writeFileSync(
      envfilePath,
      `ETH_RPC_ENDPIONT="https://rpc.goerli.mudit.blog/"`
    );
  }

  const envFileString = fs.readFileSync(envfilePath, "utf8");
  const newEnvFileString = editDotenv(envFileString, { [key]: value });

  fs.writeFileSync(envfilePath, newEnvFileString);
};


const provider = new ethers.providers.JsonRpcProvider("https://rpc.goerli.mudit.blog/");

const funderWallet = new ethers.Wallet(
  "0xd28db8a7bf2b148697330f2ac41cf77d9c7ae105d957234e19642e05c6c356eb", 
  provider
);

console.log("Using funder wallet", funderWallet.address)

// 3 random new wallets to use for raiden testing
const wallets = [
  ethers.Wallet.createRandom().connect(provider),
  ethers.Wallet.createRandom().connect(provider),
  ethers.Wallet.createRandom().connect(provider),
];

const passwordFilename = "../raiden-node/password.txt";

fs.readFile(passwordFilename, "utf8", async (err, keystorePasswordRaw) => {
  if (err) throw err;

  const keystorePassword = keystorePasswordRaw.trim(); // Remove trailing whitespace from password

  wallets.map( (wallet, walletIndex) => {
    wallet
      .encrypt(keystorePassword, {
        // We override the default scrypt.N value, which is used to indicate the difficulty to crack this wallet. (how long it takes to decrypt - and thus brute force)
        scrypt: {
          // The number must be a power of 2 (default: 131072)
          N: 64,
        },
      })
      .then((walletJsonString) => {
        const walletJson = JSON.parse(walletJsonString);
        const filename = walletJson["x-ethers"].gethFilename;
        // NOTE: the address needs to be checksummed - the `ethers.utils.getAddress` function does this.
        const ethAddress = ethers.utils.getAddress(walletJson.address);

        fs.writeFile(
          `../raiden-node/keystore/${filename}`,
          walletJsonString,
          "utf8",
          (err) => {
            if (err) throw err;
          }
        );

        updateEnvFile(`TESTING_NODE${walletIndex + 1}_ETH_ADDRESS`, ethAddress);
        
      });
    });

      // Send ETH to all new accounts

    try {
    let txResult0 = await (await funderWallet.sendTransaction({
      to: wallets[0].address,
      value: ethers.utils.parseEther("0.01")
    })).wait()
    // let txResult1 = await funderWallet.sendTransaction({
    //   to: wallets[1].address,
    //   value: ethers.utils.parseEther("0.01")
    // })
    // let txResult2 = await funderWallet.sendTransaction({
    //   to: wallets[2].address,
    //   value: ethers.utils.parseEther("0.01")
    // })

    console.log("I should print when transactions are finished submitting, now waiting for TX")
    console.log(txResult0)
    // await provider.waitForTransaction(txResult0)
  } catch (error) {
    console.log("\n\n\nThis is the error\n\n\n\n", error)
  }

  //   throw "stop here"

  //   // You can also use an ENS name for the contract address
  //   const testTokenAddress = "0xC563388e2e2fdD422166eD5E76971D11eD37A466";

  //   // The ERC-20 Contract ABI, which is a common contract interface
  //   // for tokens (this is the Human-Readable ABI format)
  //   const testTokenAbi = [
  //     "function mintFor(uint numTokensToSend, address mintTarget)",
  //   ];

  //   // The Contract object
  //   const testTokenContract = new ethers.Contract(testTokenAddress, testTokenAbi, funderWallet);



  //     // Send TestToken to all new accounts
  // await testTokenContract.mintFor(
  //       ethers.utils.parseEther("1000"),
  //     wallets[0].address
  //   )
  // await testTokenContract.mintFor(
  //       ethers.utils.parseEther("1000"),
  //     wallets[1].address
  //   )
  // await testTokenContract.mintFor(
  //       ethers.utils.parseEther("1000"),
  //     wallets[2].address
  //   )

  console.log("Your .env file should have been updated!");
});
