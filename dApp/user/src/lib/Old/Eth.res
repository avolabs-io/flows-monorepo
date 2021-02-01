type t = BN.t

// Float
let toFixedWithPrecisionNoTrailingZeros = (number: float, ~digits) =>
  number->Js.Float.toFixedWithPrecision(~digits)->float_of_string->Float.toString

@deriving(jsConverter)
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

@module("web3-utils") external fromWei: (t, string) => string = "fromWei"
@dead("+toWei") @module("web3-utils") external toWei: (string, string) => string = "toWei"

let fromWeiEth: t => string = value => fromWei(value, ethUnitToJs(#ether))

type getUnit =
  | Eth(ethUnit)
  | Usd(float, int)

let getFloat = (value, unit) =>
  switch unit {
  | Eth(unit) => fromWei(value, unit->ethUnitToJs)->Js.Float.fromString
  | Usd(conversion, _) => fromWei(value, #ether->ethUnitToJs)->Js.Float.fromString *. conversion
  }
let get = (value, unit) =>
  switch unit {
  | Eth(unit) => fromWei(value, unit->ethUnitToJs)
  | Usd(conversion, digits) =>
    (fromWei(value, #ether->ethUnitToJs)->Js.Float.fromString *. conversion)
      ->toFixedWithPrecisionNoTrailingZeros(~digits)
  }

let make: string => option<t> = wei => {
  let result = Helper.isPositiveStringInteger(wei) ? Some(BN.new_(wei)) : None
  result
}
@dead("+makeWithDefault")
let makeWithDefault: (string, int) => t = (tokenId, default) =>
  switch make(tokenId) {
  | Some(wei) => wei
  | None => default->Int.toString->BN.new_
  }
@dead("+makeFromInt") let makeFromInt: int => t = tokenId => tokenId->Int.toString->BN.new_

@dead("+makeFromEthStr")
let makeFromEthStr: string => option<t> = eth =>
  Float.fromString(eth)->Option.flatMap(ethFloat => Some(
    BN.new_(toWei(Float.toString(ethFloat), "ether")),
  ))

let toFixedWithPrecisionNoTrailingZeros = (~digits=9, eth) =>
  eth
  ->fromWeiEth
  ->Float.fromString
  ->Option.getWithDefault(0.)
  ->toFixedWithPrecisionNoTrailingZeros(~digits)
