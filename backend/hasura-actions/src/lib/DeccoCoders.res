// NOTE: this Decoder doesn't catch any parsing errors:
let bnDecoder = bnJsonString => bnJsonString->GqlConverters.BigInt.parse->Belt.Result.Ok

let bnCoder = (GqlConverters.BigInt.serialize, bnDecoder)
