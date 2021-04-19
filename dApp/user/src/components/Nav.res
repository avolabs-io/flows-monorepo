@react.component
let make = () => {
  let user = RootProvider.useCurrentUser()
  let network = RootProvider.useNetworkName()
  let logout = RootProvider.useDeactivateWeb3()

  <div className="container mx-auto py-4">
    <div className="flex justify-between items-center">
      <a href="https://flows.finance" className="flex items-center">
        <img src="/img/flows_finance_logo.svg" className="h-10" />
        <h2 className="pl-4 text-xl"> {"Flows Finance"->React.string} </h2>
      </a>
      {switch user {
      | Some(userAddress) =>
        <ul className="flex items-center">
          <li
            className="pl-4 uppercase flex items-center cursor-pointer"
            onClick={_e => ReasonReactRouter.push("/")}>
            <img src="/img/icons/dashboard.svg" className="h-3 pr-1" /> {"Dashboard"->React.string}
          </li>
          <li
            className="pl-4 uppercase flex items-center cursor-pointer"
            onClick={_e => ReasonReactRouter.push("stream")}>
            <img src="/img/icons/stream.svg" className="h-3 pr-1" /> {"Create Stream"->React.string}
          </li>
          <li
            className="pl-4 uppercase flex items-center cursor-pointer"
            onClick={_e => ReasonReactRouter.push("contacts")}>
            <img src="/img/icons/contacts.svg" className="h-3 pr-1" /> {"Contacts"->React.string}
          </li>
          <li className="pl-4 flex  items-center">
            <DisplayAddress address={userAddress->Ethers.Utils.ethAdrToStr} />
            <img
              src="/img/icons/logout.svg"
              className="h-3 pl-1  cursor-pointer"
              onClick={_e => {logout()}}
            />
          </li>
          <li className="pl-4">
            <div className="rounded-md py-1 px-3 bg-indigo-600 bg-opacity-25 uppercase">
              {network->React.string}
            </div>
          </li>
        </ul>
      | None => <button className="uppercase px-2"> {"connect"->React.string} </button>
      }}
    </div>
  </div>
}
