type t

@new @module("raiden-ts") external create: (Ethers.Providers.t, Ethers.Wallet.t) => t = "create"
