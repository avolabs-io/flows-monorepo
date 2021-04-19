@react.component
let make = () => {
  <div className="container max-w-3xl mx-auto">
    <div className="grid grid-cols-1 gap-4  md:grid-cols-2">
      <div className="">
        <Heading> {"Token Balances"->React.string} </Heading>
        <p> {"TTT: 123"->React.string} </p>
        <p> {"DAI: 1249"->React.string} </p>
        <p> {"RDN: 9311"->React.string} </p>
      </div>
      <div className="">
        <Heading> {"Wallet actions"->React.string} </Heading>
        <button
          onClick={_ => Js.log("deposit")}
          className="mt-3 w-full inline-flex justify-center border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm">
          {"Deposit"->React.string}
        </button>
        <button
          onClick={_ => Js.log("Withdraw")}
          className="mt-3 w-full inline-flex justify-center border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
          {"Withdraw"->React.string}
        </button>
        <button
          onClick={_ => Js.log("Send")}
          className="mt-3 w-full inline-flex justify-center border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
          {"Send"->React.string}
        </button>
      </div>
    </div>
    <div className="grid grid-cols-">
      <Heading> {"Outgoing streams"->React.string} </Heading> <StreamsTable />
    </div>
  </div>
}
