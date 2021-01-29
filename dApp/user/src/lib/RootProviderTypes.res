type injectedType = {@dead("injectedType.isAuthorized") isAuthorized: unit => JsPromise.t<bool>}
type web3reactContext = {
  @dead("web3reactContext.active") active: bool,
  @dead("web3reactContext.activate")
  activate: (injectedType, unit => unit, bool) => JsPromise.t<unit>,
  @dead("web3reactContext.account") account: option<Web3.ethAddress>,
  @dead("web3reactContext.library") library: option<Web3.web3Library>,
  @dead("web3reactContext.chainId") chainId: option<int>,
}

type rec rootActions =
  | Logout
  | LoadAddress(Web3.ethAddress, option<Eth.t>)
type ethState =
  | Disconnected
  | Connected(Web3.ethAddress, option<Eth.t>)

type state = {ethState: ethState}
