@react.component
let make = () => {
  <div className="flex flex-col">
    <div className="my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
      <div className="py-2 align-middle inline-block min-w-full sm:px-2 lg:px-8">
        <div className="shadow overflow-hidden border-b border-gray-200">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th
                  scope="col"
                  className="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Receiver"->React.string}
                </th>
                <th
                  scope="col"
                  className="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Token"->React.string}
                </th>
                <th
                  scope="col"
                  className="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Amount"->React.string}
                </th>
                <th
                  scope="col"
                  className="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Progress"->React.string}
                </th>
                <th
                  scope="col"
                  className="px-2 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Auto"->React.string} <br /> {"renew"->React.string}
                </th>
                <th scope="col" className="relative px-2 py-3">
                  <span className="sr-only"> {"Edit"->React.string} </span>
                </th>
                <th scope="col" className="relative px-2 py-3">
                  <span className="sr-only"> {"Delete"->React.string} </span>
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              <tr>
                <td className="px-2 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      <img
                        src={Blockies.makeBlockie("0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B")}
                      />
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-medium text-gray-900">
                        {"Arthur Kambrook"->React.string}
                      </div>
                      <div className="text-sm text-gray-500">
                        <DisplayAddress address="0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B" />
                      </div>
                    </div>
                  </div>
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"DAI"->React.string}
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"950"->React.string}
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500 w-full">
                  <div className="relative pt-1 ">
                    <div
                      className="flex items-center overflow-hidden h-7 mb-4 text-xs text-white justify-between bg-blue-200">
                      <div
                        className="shadow-none w-14 flex-row whitespace-nowrap  bg-blue-400 h-7 items-center">
                        <p> {"8th Apr 21"->React.string} </p>
                      </div>
                      <p> {"7th Apr 22"->React.string} </p>
                    </div>
                  </div>
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500">
                  <div className="">
                    <input
                      className="h-6 w-6"
                      type_="checkbox"
                      checked={true}
                      onChange={_ => Js.log("Changed")}
                    />
                  </div>
                </td>
                <td className="py-4">
                  <div className="ml-1">
                    <button
                      onClick={_ => Js.log("edit")}
                      className="mt-3 justify-center border border-gray-300 shadow-sm py-2 px-3 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-1 sm:w-auto">
                      <img src="/img/icons/edit.svg" className="h-4 w-4" />
                    </button>
                  </div>
                </td>
                <td className="py-4">
                  <div className="mr-1">
                    <button
                      onClick={_ => Js.log("delete")}
                      className="mt-3 justify-center border border-gray-300 shadow-sm py-2 px-3 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-1 sm:w-auto">
                      <img src="/img/icons/delete.svg" className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
              <tr>
                <td className="px-2 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      <img
                        src={Blockies.makeBlockie("0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8")}
                      />
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-medium text-gray-900">
                        {"Wello Horld"->React.string}
                      </div>
                      <div className="text-sm text-gray-500">
                        <DisplayAddress address="0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8" />
                      </div>
                    </div>
                  </div>
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"DAI"->React.string}
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"3050"->React.string}
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500 w-full">
                  <div className="relative pt-1 ">
                    <div
                      className="flex items-center overflow-hidden h-7 mb-4 text-xs text-white justify-between bg-blue-200">
                      <div
                        className="shadow-none w-10 flex-row whitespace-nowrap  bg-blue-400 h-7 items-center">
                        <p> {"2nd Feb 21"->React.string} </p>
                      </div>
                      <p> {"2nd Feb 21"->React.string} </p>
                    </div>
                  </div>
                </td>
                <td className="px-2 py-4 whitespace-nowrap text-sm text-gray-500">
                  <div className="">
                    <input
                      className="h-6 w-6"
                      type_="checkbox"
                      checked={true}
                      onChange={_ => Js.log("Changed")}
                    />
                  </div>
                </td>
                <td className="py-4">
                  <div className="ml-1">
                    <button
                      onClick={_ => Js.log("edit")}
                      className="block mt-3 justify-center border border-gray-300 shadow-sm py-2 px-3 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-1 sm:w-auto">
                      <img src="/img/icons/edit.svg" className="h-4 w-4" />
                    </button>
                  </div>
                </td>
                <td className="py-4">
                  <div className="mr-1">
                    <button
                      onClick={_ => Js.log("delete")}
                      className="mt-3 justify-center border border-gray-300 shadow-sm py-2 px-3 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:ml-1 sm:w-auto">
                      <img src="/img/icons/delete.svg" className="h-4 w-4" />
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
}
