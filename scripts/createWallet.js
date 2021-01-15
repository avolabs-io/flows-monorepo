const { ethers } = require("ethers");
const fs = require("fs");

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

  console.log(
    "Add the following 3 lines to your .env file when running (remove the old variables if you have done this before)"
  );

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

        // Print text to add to `.env` file to console:
        console.log(`NODE${walletIndex + 1}_ETH_ADDRESS="${ethAddress}"`);
      });
  });
});
