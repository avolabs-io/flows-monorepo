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

// 3 random new wallets to use for raiden testing
const wallets = [
  ethers.Wallet.createRandom(),
  ethers.Wallet.createRandom(),
  ethers.Wallet.createRandom(),
];

const passwordFilename = "../raiden-node/password.txt";
fs.readFile(passwordFilename, "utf8", (err, keystorePasswordRaw) => {
  if (err) throw err;

  const keystorePassword = keystorePasswordRaw.trim(); // Remove trailing whitespace from password

  wallets.map((wallet, walletIndex) => {
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

        updateEnvFile(`NODE${walletIndex + 1}_ETH_ADDRESS`, ethAddress);
      });
  });

  console.log("Your .env file should have been updated!");
});
