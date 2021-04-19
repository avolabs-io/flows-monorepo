type injectedType = {@dead("injectedType.isAuthorized") isAuthorized: unit => JsPromise.t<bool>}
type web3reactContext = {
  @dead("web3reactContext.active") active: bool,
  @dead("web3reactContext.activate")
  activate: (injectedType, unit => unit, bool) => JsPromise.t<unit>,
  @dead("web3reactContext.account") account: option<Ethers.ethAddress>,
  @dead("web3reactContext.library") library: option<Ethers.Providers.t>,
  @dead("web3reactContext.chainId") chainId: option<int>,
}

type rec rootActions =
  | Logout
  | LoadAddress(Ethers.ethAddress, option<Ethers.BigNumber.t>)
type ethState =
  | Disconnected
  | Connected(Ethers.ethAddress, option<Ethers.BigNumber.t>)

type state = {ethState: ethState}
