type provider

module HdWalletProvider = {
  type mnemonicPhrase = string
  type mnemonic = {phrase: mnemonicPhrase}
  type providerUrl = string
  type hdWalletConfig = {
    mnemonic: mnemonic,
    providerOrUrl: providerUrl,
  }

  @new @module
  external new_: hdWalletConfig => provider = "@truffle/hdwallet-provider"
}

module PrivateKeyProvider = {
  type privateKey = string
  type providerUrl = string

  @new @module
  external new_: (privateKey, providerUrl) => provider = "truffle-privatekey-provider"
}

module Web3 = {
  type t

  @new @module external make: unit => t = "web3";
  @new @module external new_: provider => t = "web3"

  @send @scope("eth")
  external sign: (t, string, string) => Js.Promise.t<string> = "sign"

  @send @scope(("eth", "accounts"))
  external ecRecover: (t, string, string) => string = "recover";

// type ethAddress = string;

// type ethersBigNumber = {toString: (. unit) => string};
// type rawProvider;

// type web3Library = {
//   getBalance: (. ethAddress) => Js.Promise.t(option(ethersBigNumber)),
//   getSigner: (. ethAddress) => web3Library,
//   provider: rawProvider,
// };

// [@bs.module "ethers"] [@bs.scope "providers"] [@bs.new]
// external makeJsonRpcProvider: string => web3Library = "JsonRpcProvider";
}

module EthereumAbi = {
  type sha3

  type ethereumType = string
  type ethereumValue = string
  @module("ethereumjs-abi")
  external soliditySHA3: (array<ethereumType>, array<ethereumValue>) => sha3 = "soliditySHA3"

  @send external sha3ToString: (sha3, string) => string = "toString"
}

type ethSig = {
  signature: string,
  r: string,
  s: string,
  v: int,
}

@bs.send external slice: (string, int, int) => string = "slice"
@bs.val external parseInt: (string, int) => int = "parseInt"

let getEthSig = sigString => {
  signature: sigString,
  r: sigString->slice(0, 66),
  s: "0x" ++ sigString->slice(66, 130),
  v: parseInt(sigString->slice(130, 132), 16),
}

let ethPrefix = "\x19Ethereum Signed Message:\n32"
