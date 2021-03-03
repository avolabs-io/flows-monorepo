open Ethers.Utils

let setSignInData = (~ethAddress: string, ~ethSignature: string) => Dom.Storage2.localStorage->Dom.Storage2.setItem(ethAddress, ethSignature)

@react.component
let make = () => {
    let signer = RootProvider.useSignerExn()
    let userAddress = RootProvider.useCurrentUserExn()
    let { setIsAuthorized } = AuthProvider.useAuthStatus()
    <button
        onClick={(_) => {
            let _ = Ethers.Wallet.signMessage(
            signer,
            `flows.finance-signin-string:${userAddress->ethAdrToStr}`,
            )->JsPromise.map(result => {
                setSignInData(~ethAddress=userAddress->ethAdrToLowerStr, ~ethSignature=result->Js.String2.make)
                setIsAuthorized(_ => true)
            })
        }}
    >
    {"Authenticate"->React.string}
    </button>
}