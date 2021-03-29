@react.component
let make = () => {
  <div className=" flex my-2 p-1 border-2 border-indigo-600 items-center justify-between">
    <div className="flex flex-col">
      <div> {"To"->React.string} </div> <div className="text-lg"> {"James"->React.string} </div>
    </div>
    <div className="flex flex-col">
      <div> {"Token"->React.string} </div> <div className="text-lg"> {"TTT"->React.string} </div>
    </div>
    <div className="flex flex-col">
      <div> {"Amount"->React.string} </div> <div className="text-lg"> {"3000"->React.string} </div>
    </div>
    <div className="flex flex-row">
      //    Progress bar that goes over the start and end date with the amount streamed showing when hovering over
      <div> {"start date"->React.string} </div>
      <div className=""> {"end date"->React.string} </div>
    </div>
    <div className="flex flex-col">
      <div> {"Auto renew"->React.string} </div>
      <div className="">
        <input type_="checkbox" checked={true} onChange={_ => Js.log("Changed")} />
      </div>
    </div>
    <div className="flex flex-row">
      <div className="border m-1 p-2 border-indigo-600">
        <img src="/img/icons/edit.svg" className="h-4" />
      </div>
      <div className="border m-1 p-2 border-indigo-600">
        <img src="/img/icons/delete.svg" className="h-4" />
      </div>
    </div>
  </div>
}
