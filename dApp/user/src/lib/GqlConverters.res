module BigInt = {
  type t = Ethers.BigNumber.t
  let parse = Ethers.BigNumber.fromUnsafe
  let serialize = Ethers.BigNumber.toString
}

module IntToBigInt = {
  type t = Ethers.BigNumber.t
  let parse = Ethers.BigNumber.fromInt
  let serialize = Ethers.BigNumber.toNumber
}

module Bytes = {
  type t = string
  let parse = json =>
    switch json->Js.Json.decodeString {
    | Some(str) => str
    | None =>
      // In theory graphql should never allow this to not be a correct string
      Js.log("CRITICAL - should never happen!")
      "couldn't decode bytes"
    }
  let serialize = bytesString => bytesString->Js.Json.string
}
