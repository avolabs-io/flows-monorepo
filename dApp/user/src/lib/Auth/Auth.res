open Ethers
open Utils

module LocalStorage = {


  let currentLoginKey = "CurrentUserLoggedIn"

  
  let get = (item) => {
    let fn = Dom.Storage2.getItem(_, item)
    fn(Dom.Storage2.localStorage)
  }

  let set = (key, item) => {
    Dom.Storage2.localStorage->Dom.Storage2.setItem(key, item)
  }

  let setSignInData = 
    (~ethAddress, ~ethSignature: string) => 
      set(ethAddress->ethAdrToLowerStr, ethSignature)

  let setCurrentUser = 
    (~ethAddress: ethAddress) => 
      set(currentLoginKey, ethAddress->ethAdrToLowerStr)

  let getUserSignatureOpt = u => u->get

  let getCurrentLoggedInUserOpt = () => 
    get(currentLoginKey)
    ->Option.flatMap(Ethers.Utils.getAddress)
}

module Headers = {

  type clientHeaders = {
    @as("eth-address")
    ethAddress: string,
    @as("eth-signature")
    ethSignature: string,
  }

  let make = (~user) => {
    LocalStorage.getUserSignatureOpt(user->ethAdrToLowerStr)
    ->Option.flatMap(ethSignature => 
      Some({
        ethAddress: user->ethAdrToStr,
        ethSignature
      })
    )
  }

  let makeFromOpt = 
    (~optUser: option<ethAddress>) => 
      optUser->Option.flatMap((user) => make(~user))

}
