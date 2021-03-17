@react.component
let make = () => {
  let optWeb3Provider = RootProvider.useWeb3()
  let optSigner = RootProvider.useSigner()

  let {loggedInStatus} = AuthProvider.useAuthStatus()

  React.useEffect2(() => {
    switch (optWeb3Provider, optSigner) {
    | (Some(web3Provider), Some(_signer)) => {
        let _ = Raiden.createIndex(web3Provider, 0)
      }
    | _ => ()
    }
    None
  }, (optWeb3Provider, optSigner))
  <div>
    {switch loggedInStatus {
    | Web3Only => <AuthenticateButton />
    | NotLoggedIn => React.null
    | _ => <> <ViewStreams /> <CreatePayment /> </>
    }}
  </div>
}

// let userAddress = ""
// PaymentStreamManager.gqlClient.query(
//                 ~query=module(Query.ViewPaymentsStreamsWithAddress),
//                 Query.ViewPaymentsStreamsWithAddress.makeVariables(~address=userAddress, ()),
//               )
//               ->JsPromise.map(result =>
//                 switch result {
//                 | Ok({data: {payments}}) =>
//                   let _ = Array.map(payments, payment => {
//                     let id = payment.id
//                   })
//                 | Error(error) => Js.log2("error last payment: ", error)
//                 }
//               )
//               ->ignore
