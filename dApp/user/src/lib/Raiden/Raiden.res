open Ethers.Utils

type t

@module("raiden-ts")
external create: (Ethers.Providers.t, Ethers.Wallet.t) => JsPromise.t<t> = "create"

@module("raiden-ts") @scope("Raiden")
external createIndex: (Ethers.Providers.t, int) => JsPromise.t<t> = "create"

@module("raiden-ts") @scope("Raiden")
external createWallet: (Ethers.Providers.t, Ethers.Wallet.t) => JsPromise.t<t> = "create"

type transferIdentifier

let transferIdentifierToStr: transferIdentifier => string = Obj.magic

type secret = string

@ocaml.doc("Open a channel on the tokenNetwork for given token address with partner") @send
external openChannel: (
  t,
  ~token: Ethers.ethAddress,
  ~partner: Ethers.ethAddress,
) => Js.Promise.t<Ethers.txHash> = "openChannel"

@ocaml.doc("Deposit tokens on channel between us and partner on tokenNetwork for token") @send
external depositChannel: (
  t,
  ~token: Ethers.ethAddress,
  ~partner: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => Js.Promise.t<Ethers.txHash> = "depositChannel"

@ocaml.doc("Send a locked transfer. Status can be queried by subscribing to the Transfers module")
@send
external transfer: (
  t,
  ~token: Ethers.ethAddress,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => Js.Promise.t<transferIdentifier> = "transfer"

@ocaml.doc("Requests to withdraw from the channel") @send
external withdrawChannel: (
  t,
  ~token: Ethers.ethAddress,
  ~recipient: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t=?,
  unit,
) => Js.Promise.t<Ethers.txHash> = "withdrawChannel"

@ocaml.doc(
  "Close channel between us and partner on tokenNetwork for token. Will fail if called on a channel not in 'opened' or 'closing' state"
)
@send
external closeChannel: (
  t,
  ~token: Ethers.ethAddress,
  ~partner: Ethers.ethAddress,
) => Js.Promise.t<string> = "closeChannel"

@ocaml.doc(
  "Settle channel between us and partner on tokenNetwork for token. Will fail if channel not in 'settling' or 'settleable' state."
)
@send
external settleChannel: (
  t,
  ~token: Ethers.ethAddress,
  ~partner: Ethers.ethAddress,
) => Js.Promise.t<Ethers.txHash> = "settleChannel"

@ocaml.doc("Starts the Raiden store and all observables.") @send
external start: t => Js.Promise.t<unit> = "start"

@ocaml.doc(
  "Whether Raiden SDK has started. @returns None if not started, true if running, false if stopped"
)
@send
external started: t => option<bool> = "started"

@ocaml.doc("Stops the Raiden store and disconnects") @send
external stop: t => Js.Promise.t<unit> = "stop"

type networkT = {
  name: string,
  chainId: int,
  ensAddress: option<string>,
}
@ocaml.doc("Get current network from provider") @send
external network: t => option<networkT> = "network"

@send
external getBlockNumber: t => Js.Promise.t<int> = "getBlockNumber"

@ocaml.doc("Gets balance of raiden instance if address ommited") @send
external getEthBalance: (
  t,
  ~address: Ethers.ethAddress=?,
  unit,
) => Js.Promise.t<Ethers.BigNumber.t> = "getBalance"

@ocaml.doc("Scans initially and start monitoring a token, returning its Tokennetwork
address. Throws an exception if token isn't registered in current registry. 
@returns address of TokenNetwork contract")
@send
external monitorToken: (t, ~token: Ethers.ethAddress) => Js.Promise.t<Ethers.ethAddress> =
  "monitorToken"

@ocaml.doc("Returns a list of all token addresses registered as token networks in registry") @send
external getTokenList: t => Js.Promise.t<Ethers.ethAddress> = "getTokenList"

@ocaml.doc("Get token balance for given address or self. Must be one of the monitored tokens") @send
external getTokenBalance: (
  t,
  ~token: Ethers.ethAddress,
  ~address: Ethers.ethAddress=?,
  unit,
) => Js.Promise.t<Ethers.BigNumber.t> = "getTokenBalance"

@ocaml.doc("Mints the amount of tokens of the provided token address. Throws exception on main net")
@send
external mint: (
  t,
  ~token: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t,
) => Js.Promise.t<Ethers.txHash> = "mint"

@ocaml.doc("Fetches balance of UserDeposit Contract for SDK's account minus cached spent IOUs")
@send
external getUDCCapacity: t => Js.Promise.t<Ethers.BigNumber.t> = "getUDCCapacity"

@ocaml.doc("Deposit to UDC, returning transaction hash") @send
external depositToUDC: (t, ~amount: Ethers.BigNumber.t) => Js.Promise.t<Ethers.txHash> =
  "depositToUDC"

@ocaml.doc("Plan withdraw from UDC / withdraw - need to test this") @send
external planUDCWithdraw: (t, ~amount: Ethers.BigNumber.t) => Js.Promise.t<Ethers.txHash> =
  "planUdcWithdraw"

@ocaml.doc("Transfer ETH on-chain to address. If amount is unspecified defaults to max uint256")
@send
external transferOnchainBalance: (
  t,
  ~address: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t=?,
  unit,
) => Js.Promise.t<Ethers.txHash> = "transferOnchainBalance"

@ocaml.doc("Transfer tokens on-chain to address. If amount is unspecified defaults to max uint256")
@send
external transferOnchainTokens: (
  t,
  ~address: Ethers.ethAddress,
  ~amount: Ethers.BigNumber.t=?,
  unit,
) => Js.Promise.t<Ethers.txHash> = "transferOnchainTokens"

@ocaml.doc("Bindings for the channels$ observable")
module Channels = {
  type channelState = [
    | #"open"
    | #closing
    | #closed
    | #settleable
    | #settling
    | #settled
  ]
  type channel = {
    state: channelState,
    id: int,
    token: Ethers.ethAddress,
    tokenNetwork: Ethers.ethAddress,
    settleTimeout: int,
    openBlock: int,
    closeBlock: option<int>,
    partner: Ethers.ethAddress,
    balance: Ethers.BigNumber.t,
    capacity: Ethers.BigNumber.t,
  }

  type channelsObjRaw = Js.Dict.t<Js.Dict.t<channel>>
  @send @scope("channels$") external subscribe: (t, channelsObjRaw => unit) => unit = "subscribe"

  type t = channelsObjRaw

  let getKeysAsAddresses = (dict): array<Ethers.ethAddress> => dict->Js.Dict.keys->Obj.magic

  let tokens = (t): array<Ethers.ethAddress> => t->getKeysAsAddresses

  let partners = (t, ~tokenAddress) =>
    t->Js.Dict.get(tokenAddress->ethAdrToStr)->Option.map(dict => dict->getKeysAsAddresses)

  let partnersExn = (t, ~tokenAddress) => partners(t, ~tokenAddress)->Option.getExn
  let partnersUnsafe = (t, ~tokenAddress) => t->partners(~tokenAddress)->Option.getUnsafe

  let get = (t, ~tokenAddress, ~partnerAddress) =>
    t
    ->Js.Dict.get(tokenAddress->ethAdrToStr)
    ->Option.flatMap(x => x->Js.Dict.get(partnerAddress->ethAdrToStr))

  let getExn = (t, ~tokenAddress, ~partnerAddress) =>
    t->get(~tokenAddress, ~partnerAddress)->Option.getExn

  let getUnsafe = (t, ~tokenAddress, ~partnerAddress) =>
    t->get(~tokenAddress, ~partnerAddress)->Option.getUnsafe
}

type metaDataType = {route: array<Ethers.ethAddress>}

@ocaml.doc("Bindings for the transfers$ observable")
module Transfers = {
  type transferStatus = [
    | #PENDING
    | #RECIEVED
    | #CLOSED
    | #REQUESTED
    | #REVEALED
    | #REGISTERED
    | #UNLOCKING
    | #EXPIRING
    | #UNLOCKED
    | #EXPIRED
  ]

  type direction = [
    | #sent
    | #recieved
  ]

  type transfer = {
    key: transferIdentifier,
    secrethash: Ethers.txHash,
    status: transferStatus,
    initiator: Ethers.ethAddress,
    partner: Ethers.ethAddress,
    metadata: metaDataType,
    paymentId: Ethers.BigNumber.t,
    chainId: int,
    token: Ethers.ethAddress,
    tokenNetwork: Ethers.ethAddress,
    channelId: Ethers.BigNumber.t,
    value: Ethers.BigNumber.t,
    fee: Ethers.BigNumber.t,
    amount: Ethers.BigNumber.t,
    expirationBlock: int,
    startedAt: Js.Date.t,
    changedAt: Js.Date.t,
    success: option<bool>,
    completed: bool,
    secret: option<string>,
  }

  type transfersObjRaw = Js.Dict.t<transfer>
  @send @scope("transfers$") external subscribe: (t, transfersObjRaw => unit) => unit = "subscribe"

  type t = transfersObjRaw

  let transferIdentifiers = (t): array<transferIdentifier> => t->Js.Dict.keys->Obj.magic

  let get = (t, ~transferIdentifier) => t->Js.Dict.get(transferIdentifier)

  let getExn = (t, ~transferIdentifier) => t->get(~transferIdentifier)->Option.getExn

  let getUnsafe = (t, ~transferIdentifier) => t->get(~transferIdentifier)->Option.getUnsafe
}

@ocaml.doc("Waits for the transfer identified by a secrethash to fail or complete.") @send
external waitTransfer: (
  t,
  ~transferIdentifier: transferIdentifier,
) => Js.Promise.t<Transfers.transferStatus> = "waitTransfer"
