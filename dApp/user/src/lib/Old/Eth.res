open Ethers
open Utils

type t =BigNumber.t

// Float
let toFixedWithPrecisionNoTrailingZeros = (number: float, ~digits) =>
  number->Js.Float.toFixedWithPrecision(~digits)->float_of_string->Float.toString

type getUnit =
  | Eth(ethUnit)
  | Usd(float, int)

let getFloat = (value, unit) =>
  switch unit {
  | Eth(unit) =>formatUnits(.value, unit)->Js.Float.fromString
  | Usd(conversion, _) =>formatEther(value)->Js.Float.fromString *. conversion
  }
let get = (value, unit) =>
  switch unit {
  | Eth(unit) =>formatUnits(.value, unit)
  | Usd(conversion, digits) =>
    (formatEther(value)->Js.Float.fromString *. conversion)
      ->toFixedWithPrecisionNoTrailingZeros(~digits)
  }

let make: string => option<t> = wei => {
  let result = Helper.isPositiveStringInteger(wei) ? Some(BigNumber.fromUnsafe(wei)) : None // should be safe if helper fn returns true
  result
}
@dead("+makeWithDefault")
let makeWithDefault: (string, int) => t = (tokenId, default) =>
  switch make(tokenId) {
  | Some(wei) => wei
  | None => default ->BigNumber.fromInt
  }
@dead("+makeFromInt") let makeFromInt: int => t = BigNumber.fromInt

@dead("+makeFromEthStr")
let makeFromEthStr: string => option<t> = (eth) =>parseEther(~amount=eth)

let toFixedWithPrecisionNoTrailingZeros = (~digits=9, eth) =>
  eth
  ->formatEther
  ->Float.fromString
  ->Option.getWithDefault(0.)
  ->toFixedWithPrecisionNoTrailingZeros(~digits)
