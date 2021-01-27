type authResponse = {
  @as("X-Hasura-User-Id")
  xHasuraUserId: option<string>,
  @as("X-Hasura-Role")
  xHasuraRole: string,
  // [@bs.as "X-Hasura-Is-Owner"]
  // xHasuraIsOwner: string,
  // [@bs.as "X-Hasura-Custom"]
  // xHasuraCustom: string,
}
type headers = {
  @as("eth-signature")
  ethSignature: option<string>,
  @as("eth-address")
  ethAddress: option<string>,
  // @as("jwt-token")
  // auth: option<string>,
  // @as("eth-login-jwt")
  // ethJwt: option<string>,
}
type authInput = {headers: headers}

let validateEthSignature = (ethSignature, ethAddress) => {
  open Web3Stuff

  let web3 = Web3.make()
  let signersAddress = Web3.ecRecover(
    web3,
    "flows.finance-signin-string:" ++ ethAddress,
    ethSignature,
  )
  signersAddress == ethAddress
}

// NOT typesafe, but there is a level of trust from hasura :)
let getAuthHeaders: Express.Request.t => authInput = %raw(`
  (req) => req.body
`)
let getJwt: Express.Request.t => string = %raw(`(req) => req.jwt`)

let authResponseToJson: authResponse => Js.Json.t = Obj.magic

let endpoint = Serbet.endpoint({
  verb: POST,
  path: "/auth",
  handler: req => {
    let {headers: {ethSignature, ethAddress}} = getAuthHeaders(req.req)

    switch (ethSignature, ethAddress) {
    | (Some(ethSignature), Some(ethAddress)) =>
      Js.log(`Signing in with ${ethSignature} and ${ethAddress}`)
      if validateEthSignature(ethSignature, ethAddress) {
        {xHasuraUserId: Some(ethAddress), xHasuraRole: "user"}
        ->authResponseToJson
        ->Serbet.Endpoint.OkJson
        ->Js.Promise.resolve
      } else {
        Serbet.Endpoint.Unauthorized("")->Js.Promise.resolve
      }
    | _ =>
      Js.log("the login details aren't provided using public")
      {xHasuraUserId: None, xHasuraRole: "public"}->authResponseToJson->Serbet.Endpoint.OkJson->Js.Promise.resolve
    }
  },
})
