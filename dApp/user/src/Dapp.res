@react.component
let make = () => {
  let optWeb3Provider = RootProvider.useWeb3()
  let optSigner = RootProvider.useSigner()

  React.useEffect2(() => {
    switch (optWeb3Provider, optSigner) {
    | (Some(web3Provider), Some(_signer)) => {
        let _ = Raiden.createIndex(web3Provider, 0)
      }
    | _ => ()
    }
    None
  }, (optWeb3Provider, optSigner))
  <div> <p> {"something"->React.string} </p> </div>
}