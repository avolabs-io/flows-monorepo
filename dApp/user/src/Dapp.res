@react.component
let make = () => {
  let optWeb3Provider = RootProvider.useWeb3()
  let optSigner = RootProvider.useSigner()

  let {isAuthorized} = AuthProvider.useAuthStatus()

  React.useEffect2(() => {
    switch (optWeb3Provider, optSigner) {
    | (Some(web3Provider), Some(signer)) => {
        let _ = Raiden.createWallet(web3Provider, signer)->JsPromise.map(t => Js.log(t))
      }
    | _ => ()
    }
    None
  }, (optWeb3Provider, optSigner))
  <div>
    {if !isAuthorized {
      <AuthenticateButton />
    } else {
      <SignUp />
    }}
    <p> {"something"->React.string} </p>
  </div>
}
