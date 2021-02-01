type t

@module("raiden-ts")
external create: (Ethers.Providers.t, Ethers.Wallet.t) => JsPromise.t<t> = "create"

@module("raiden-ts")
external createIndex: (Ethers.Providers.t, int) => JsPromise.t<t> = "create"
