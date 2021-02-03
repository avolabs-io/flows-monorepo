type ethAddressStr = string
type ethAddress

module Misc = {
  let unsafeToOption: (unit => 'a) => option<'a> = unsafeFunc => {
    try {
      unsafeFunc()->Some
    } catch {
    | Js.Exn.Error(_obj) => None
    }
  }
}

type txResult = {
  @dead("txResult.blockHash") blockHash: string,
  @dead("txResult.blockNumber") blockNumber: int,
  @dead("txResult.byzantium") byzantium: bool,
  @dead("txResult.confirmations") confirmations: int,
  // contractAddress: null,
  // cumulativeGasUsed: Object { _hex: "0x26063", … },
  // events: Array(4) [ {…}, {…}, {…}, … ],
  @dead("txResult.from") from: ethAddress,
  // gasUsed: Object { _hex: "0x26063", … },
  // logs: Array(4) [ {…}, {…}, {…}, … ],
  // logsBloom: "0x00200000000000008000000000000000000020000001000000000000400020000000000000002000000000000000000000000002800010000000008000000000000000000000000000000008000000000040000000000000000000000000000000000000020000014000000000000800024000000000000000000010000000000000000000000000000000000000000000008000000000000000000000000200000008000000000000000000000000000000000800000000000000000000000000001002000000000000000000000000000000000000000020000000040020000000000000000080000000000000000000000000000000080000000000200000"
  @dead("txResult.status") status: int,
  @dead("txResult._to") _to: ethAddress,
  transactionHash: string,
  @dead("txResult.transactionIndex") transactionIndex: int,
}
type txHash = string
type txSubmitted = {
  hash: txHash,
  wait: (. unit) => JsPromise.t<txResult>,
}
type txError = {
  @dead("txError.code") code: int, // -32000 = always failing tx ;  4001 = Rejected by signer.
  message: string,
  @dead("txError.stack") stack: option<string>,
}

type abi

let makeAbi = (abiArray: array<string>): abi => abiArray->Obj.magic

type ethersBigNumber

module BigNumber = {
  type t = ethersBigNumber

  @module("ethers") external from: string => t = "from"

  @send external add: (t, t) => t = "add"
  @send external sub: (t, t) => t = "sub"
  @send external mul: (t, t) => t = "mul"
  @send external div: (t, t) => t = "div"
  @send external gt: (t, t) => bool = "gt"
  @send external lt: (t, t) => bool = "lt"
  @dead("+eq") @send external eq: (t, t) => bool = "eq"
  @send external cmp: (t, t) => int = "cmp"
  @dead("+sqr") @send external sqr: t => t = "sqr"
  @send external toString: t => string = "toString"
  @send external toStringRad: (t, int) => string = "toString"

  @send external toNumber: t => int = "toNumber"
  @send external toNumberFloat: t => float = "toNumber"
}
type rawProvider
@send
external waitForTransaction: (rawProvider, string) => JsPromise.t<txResult> = "waitForTransaction"

type providerType
type walletType = {address: string, provider: providerType}

module Wallet = {
  type t = walletType

  @new @module("ethers")
  external makePrivKeyWallet: (string, providerType) => t = "Wallet"
}

module Providers = {
  type t = providerType

  @new @module("ethers") @scope("providers")
  external makeProvider: string => rawProvider = "JsonRpcProvider"

  @send external getBalance: (t, ethAddress) => JsPromise.t<option<BigNumber.t>> = "getBalance"
  @send
  external getSigner: (t, ethAddress) => option<Wallet.t> = "getSigner"
}

type providerOrSigner =
  | Provider(Providers.t)
  | Signer(Wallet.t)

module Contract = {
  type t

  type txOptions = {
    @live gasLimit: option<string>,
    @live value: BigNumber.t,
  }

  type tx = {
    hash: txHash,
    wait: (. unit) => JsPromise.t<txResult>,
  }

  @new @module("ethers")
  external getContractSigner: (ethAddress, abi, Wallet.t) => t = "Contract"
  @new @module("ethers")
  external getContractProvider: (ethAddress, abi, Providers.t) => t = "Contract"

  let make: (ethAddress, abi, providerOrSigner) => t = (address, abi, providerSigner) => {
    switch providerSigner {
    | Provider(provider) => getContractProvider(address, abi, provider)
    | Signer(signer) => getContractSigner(address, abi, signer)
    }
  }
}

module Utils = {
  type ethUnit = [
    | #wei
    | #kwei
    | #mwei
    | #gwei
    | #microether
    | #milliether
    | #ether
    | #kether
    | #mether
    | #geher
    | #tether
  ]
  @module("ethers") @scope("utils")
  external parseUnitsUnsafe: (. string, ethUnit) => BigNumber.t = "parseUnits"
  let parseUnits = (~amount, ~unit) => Misc.unsafeToOption(() => parseUnitsUnsafe(. amount, unit))

  let parseEther = (~amount) => parseUnits(~amount, ~unit=#ether)

  @module("ethers") @scope("utils")
  external getAddressUnsafe: string => ethAddress = "getAddress"
  let getAddress: string => option<ethAddress> = addressString =>
    Misc.unsafeToOption(() => getAddressUnsafe(addressString))

  let toString: ethAddress => string = Obj.magic
  let toLowerString: ethAddress => string = address => address->toString->Js.String.toLowerCase
}
