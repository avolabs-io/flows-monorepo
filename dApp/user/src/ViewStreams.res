@react.component
let make = () => {
  let user = RootProvider.useCurrentUserExn()

  let viewStreamsQuery = Queries.ViewPaymentsStreamsWithAddress.use({
    {address: user->Ethers.Utils.ethAdrToStr}
  })


  <div>
    {switch viewStreamsQuery {
    | {loading: true, data: None} => <p> {"Loading"->React.string} </p>
    | {error: Some(error)} =>
      Js.log(error)
      <p> {"Data is loaded"->React.string} </p>
    | {data: Some({
        streams
      })} => {
        streams->Array.map(({
          id,
          amount,
          interval,
          numberOfPayments,
          numberOfPaymentsMade,
          recipient,
          state,
          tokenAddress,
          startPayment,
          nextPayment,
          lastPayment
        }) => {
          <div key={id->Js.String2.make}>
              {id->Js.String2.make->React.string}
              <br/>
              {amount->Js.String2.make->React.string}
              <br/>
              {interval->Js.String2.make->React.string}
              <br/>
              {numberOfPayments->Js.String2.make->React.string}
              <br/>
              {numberOfPaymentsMade->Js.String2.make->React.string}
              <br/>
              {recipient->Js.String2.make->React.string}
              <br/>
              {state->Js.String2.make->React.string}
              <br/>
              {tokenAddress->Js.String2.make->React.string}
              <br/>
              {startPayment->Js.String2.make->React.string}
              <br/>
              {nextPayment->Js.String2.make->React.string}
              <br/>
              {lastPayment->Js.String2.make->React.string}
          </div>
        })->React.array
      }
    | {loading: false, data: None} => <p> {"Error loading data"->React.string} </p>
    }}
  </div>

}
