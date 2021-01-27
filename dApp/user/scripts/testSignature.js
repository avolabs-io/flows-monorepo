const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require("web3");

// take in private key
// create an ethereum privider with the private key (and infura)
const exampleCode = async (privateKey, publicKey) => {
  const provider = new HDWalletProvider({
    privateKeys: [privateKey],
    providerOrUrl:
      "wss://mainnet.infura.io/ws/v3/e8fe0574d5124106b82126c48b689bd9",
  });

  let web3 = new Web3(provider);

  web3.eth.getAccounts(console.log);

  const message = "flows.finance-signin-string:" + publicKey;

  const signature = await web3.eth.personal.sign(message, publicKey);

  console.log({signature});

  // const recover_2 = web3.eth.accounts.recover(message, signature);
  // console.log("recover 2 :", recover_2);

  return signature;
};

exampleCode("0xa53b388f01998f2804855c4fe8d295d13733e8e5feba0d1025cfb36af557aefa","0x77776Ff1C8a5E5BF2b2b9b3f032e2b69C0200c43")
