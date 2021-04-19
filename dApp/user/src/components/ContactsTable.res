@react.component
let make = () => {
  <div className="flex flex-col">
    <div className="my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
      <div className="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
        <div className="shadow overflow-hidden border-b border-gray-200">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th
                  scope="col"
                  className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Name"->React.string}
                </th>
                <th
                  scope="col"
                  className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {"Description"->React.string}
                </th>
                <th scope="col" className="relative px-6 py-3">
                  <span className="sr-only"> {"Edit"->React.string} </span>
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              <tr>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      <img
                        src={Blockies.makeBlockie("0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8")}
                      />
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-medium text-gray-900">
                        {"World Hello"->React.string}
                      </div>
                      <div className="text-sm text-gray-500">
                        {"0x7cB57B5A97eAbe94205C07890BE4c1aD31E486A8"->React.string}
                      </div>
                    </div>
                  </div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"Software Engineer"->React.string}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href="#" className="text-indigo-600 hover:text-indigo-900">
                    {"Edit"->React.string}
                  </a>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 whitespace-nowrap">
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
                        {"0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B"->React.string}
                      </div>
                    </div>
                  </div>
                </td>
                // <td className="px-6 py-4 whitespace-nowrap">
                //   <span
                //     className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                //     {"Active"->React.string}
                //   </span>
                // </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"Maker of fans"->React.string}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href="#" className="text-indigo-600 hover:text-indigo-900">
                    {"Edit"->React.string}
                  </a>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      <img
                        src={Blockies.makeBlockie("0x024245FEdaAb1052e4491A8e0b348D8AaF16eEE7")}
                      />
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-medium text-gray-900">
                        {"Vitalik Buterin"->React.string}
                      </div>
                      <div className="text-sm text-gray-500">
                        {"0x024245FEdaAb1052e4491A8e0b348D8AaF16eEE7"->React.string}
                      </div>
                    </div>
                  </div>
                </td>
                // <td className="px-6 py-4 whitespace-nowrap">
                //   <span
                //     className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                //     {"Active"->React.string}
                //   </span>
                // </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"Father of Ethereum"->React.string}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href="#" className="text-indigo-600 hover:text-indigo-900">
                    {"Edit"->React.string}
                  </a>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      <img
                        src={Blockies.makeBlockie("0xDa0264D7B90FF0e7EDa6e0548a542012Ccd7F34f")}
                      />
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-medium text-gray-900">
                        {"Paul Simon"->React.string}
                      </div>
                      <div className="text-sm text-gray-500">
                        {"0xDa0264D7B90FF0e7EDa6e0548a542012Ccd7F34f"->React.string}
                      </div>
                    </div>
                  </div>
                </td>
                // <td className="px-6 py-4 whitespace-nowrap">
                //   <span
                //     className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                //     {"Active"->React.string}
                //   </span>
                // </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"Great musician"->React.string}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href="#" className="text-indigo-600 hover:text-indigo-900">
                    {"Edit"->React.string}
                  </a>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="flex-shrink-0 h-10 w-10">
                      <img
                        src={Blockies.makeBlockie("0xf42C679437d08dd0d695f90b23Ca22F2e858FC2b")}
                      />
                    </div>
                    <div className="ml-4">
                      <div className="text-sm font-medium text-gray-900">
                        {"Leonardo di Caprio"->React.string}
                      </div>
                      <div className="text-sm text-gray-500">
                        {"0xf42C679437d08dd0d695f90b23Ca22F2e858FC2b"->React.string}
                      </div>
                    </div>
                  </div>
                </td>
                // <td className="px-6 py-4 whitespace-nowrap">
                //   <span
                //     className="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                //     {"Active"->React.string}
                //   </span>
                // </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {"Rose's husband"->React.string}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href="#" className="text-indigo-600 hover:text-indigo-900">
                    {"Edit"->React.string}
                  </a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
}
