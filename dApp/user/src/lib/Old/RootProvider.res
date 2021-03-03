open RootProviderTypes

type web3reactContext = {
  active: bool,
  activate: (. Web3Connectors.injectedType, unit => unit, bool) => JsPromise.t<unit>,
  account: option<Ethers.ethAddress>,
  library: option<Ethers.Providers.t>,
  chainId: option<int>,
  deactivate: unit => unit,
}
@module("@web3-react/core")
external useWeb3React: unit => web3reactContext = "useWeb3React"

module Web3ReactProvider = {
  @module("@web3-react/core") @react.component
  external make: (
    ~getLibrary: Ethers.Providers.t => Ethers.Providers.t,
    ~children: React.element,
  ) => React.element = "Web3ReactProvider"
}

@module("ethers") @scope("providers") @new
external createWeb3Provider: Ethers.Providers.t => Ethers.Providers.t = "Web3Provider"

let getLibrary = provider => {
  let library = createWeb3Provider(provider)

  let setPollingInterval: Ethers.Providers.t => Ethers.Providers.t = %raw(
    "lib => {lib.pollingInterval = 8000; return lib; }"
  )
  setPollingInterval(library)
}

let initialState = {
  ethState: Disconnected,
}

let reducer = (_prevState, action) =>
  switch action {
  | LoadAddress(address, optBalance) => {ethState: Connected(address, optBalance)}
  | Logout => {
      ethState: Disconnected,
    }
  }
module RootContext = {
  let context = React.createContext((initialState, _ => ()))
  // Create a provider component
  let make = React.Context.provider(context)

  // Tell bucklescript how to translate props into JS
  let makeProps = (~value, ~children, ()) =>
    {
      "value": value,
      "children": children,
    }
}

module RootWithWeb3 = {
  @react.component
  let make = (~children) => {
    let (rootState, dispatch) = React.useReducer(reducer, initialState)
    let context = useWeb3React()

    // This prevents repeated tries at logging in (or re-login after logout)
    let (triedLoginAlready, setTriedLoginAlready) = React.useState(() => false)
    React.useEffect5(() => {
      let _ = Web3Connectors.injected.isAuthorized()->JsPromise.map(authorised =>
        if authorised && !triedLoginAlready {
          ignore(
            context.activate(. Web3Connectors.injected, () => (), true)->JsPromise.catch(_ => {
              setTriedLoginAlready(_ => true)
            }),
          )
          ()
        } else {
          setTriedLoginAlready(_ => true)
        }
      )
      switch context.chainId {
      | None => dispatch(Logout)
      | _ => ()
      }
      None
    }, (context.activate, context.chainId, dispatch, setTriedLoginAlready, triedLoginAlready))

    // This will never fire when metamask logs out unfortunately https://stackoverflow.com/a/59215775/3103033
    //   This answer seems to give some ideas of how it can work though: https://stackoverflow.com/a/65443678/3103033
    React.useEffect1(() => {
      if context.active {
        ()
      } else {
        dispatch(Logout)
      }
      None
    }, [rootState.ethState])

    // if the connection worked, wait until we get confirmation of that to flip the flag
    React.useEffect3(() => {
      !triedLoginAlready && context.active ? setTriedLoginAlready(_ => true) : ()

      None
    }, (triedLoginAlready, context.active, setTriedLoginAlready))

    React.useEffect4(() =>
      switch (context.library, context.account) {
      | (Some(library), Some(account)) =>
        Js.log2("1", library)
        Js.log2("2", account)
        let _ =
          library
          ->Ethers.Providers.getBalance(account)
          ->JsPromise.map(newBalance =>
            dispatch(
              LoadAddress(
                account,
                newBalance->Option.flatMap(balance => Eth.make(balance->Ethers.BigNumber.toString)),
              ),
            )
          )
          ->JsPromise.catch(_ => ())

        None
      | _ => None
      }
    , (context.library, context.account, context.chainId, dispatch))

    <RootContext value=(rootState, dispatch)> children </RootContext>
  }
}

let useCurrentUser: unit => option<Ethers.ethAddress> = () => {
  let (state, _) = React.useContext(RootContext.context)
  switch state.ethState {
  | Connected(address, _balance) => Some(address)
  | Disconnected => None
  }
}

let useCurrentUserExn = () => useCurrentUser() -> Option.getExn

let useIsAddressCurrentUser: Ethers.ethAddress => bool = address => {
  let currentUser = useCurrentUser()
  switch currentUser {
  | Some(currentUserAddress) =>
    address->Ethers.Utils.ethAdrToLowerStr == currentUserAddress->Ethers.Utils.ethAdrToLowerStr
  | None => false
  }
}

let useEthBalance: unit => option<Eth.t> = () => {
  let (state, _) = React.useContext(RootContext.context)
  switch state.ethState {
  | Connected(_address, balance) => balance
  | Disconnected => None
  }
}
let useNetworkId: unit => option<int> = () => {
  let context = useWeb3React()

  context.chainId
}
let useEtherscanUrl: unit => string = () => {
  let networkId = useNetworkId()

  switch networkId {
  | Some(5) => "goerli.etherscan.io"
  | Some(4) => "rinkeby.etherscan.io"
  | _ => "etherscan.io"
  }
}
let useDeactivateWeb3: (unit, unit) => unit = () => {
  let context = useWeb3React()

  context.deactivate
}
let useWeb3: unit => option<Ethers.Providers.t> = () => {
  let context = useWeb3React()

  context.library
}
let useSigner: unit => option<Ethers.Wallet.t> = () => {
  let {library, account} = useWeb3React()

  switch (library, account) {
  | (Some(library), Some(account)) => library->Ethers.Providers.getSigner(account)
  | _ => None
  }
}

let useSignerExn = () => useSigner() -> Option.getExn

type connection =
  | Standby
  | Connected
  | Connecting
  | ErrorConnecting

@ocaml.doc("
Note: the `connectionStatus` only shows the connection status of the current connect function (not global connection status)
")
let useActivateConnector: unit => (connection, Web3Connectors.injectedType => unit) = () => {
  let context = useWeb3React()
  let (connectionStatus, setConnectionStatus) = React.useState(() => Standby)
  (
    connectionStatus,
    provider => {
      let _ =
        context.activate(. provider, () => (), true)
        ->JsPromise.map(() => setConnectionStatus(_ => Connected))
        ->JsPromise.catch(error => {
          Js.log("Error connecting to network:")
          Js.log(error)
          setConnectionStatus(_ => ErrorConnecting)
        })
      setConnectionStatus(_ => Connecting)
    },
  )
}

@react.component
let make = (~children) => {
  <Web3ReactProvider getLibrary> <RootWithWeb3> children </RootWithWeb3> </Web3ReactProvider>
}
