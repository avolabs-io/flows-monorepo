module BigInt = {
  type t = BN.t
  let parse = BN.new_
  let serialize = BN.toString
}

module IntToBigInt = {
  type t = BN.t
  let parse = BN.newInt_
  let serialize = BN.toNumber
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
