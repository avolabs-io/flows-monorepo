module StreamsInfo = {
  @react.component
  let make = (
    ~stream: FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.t_streams,
  ) => {
    let {numberOfPayments, numberOfPaymentsMade, amount, id} = stream

    let paymentsQuery = Queries.GetPaymentHistory.use({streamID: id})
    let paymentsLeft = BN.sub(numberOfPayments, numberOfPaymentsMade)
    let amountReceived = BN.mul(amount, numberOfPaymentsMade)
    <>
      <div> {`Payment amount: ${amount->BN.toString}`->React.string} </div>
      <div> {`Payments left: ${paymentsLeft->BN.toString}`->React.string} </div>
      <div> {`Payments made: ${numberOfPaymentsMade->BN.toString}`->React.string} </div>
      <div> {`Amount Recieved: ${amountReceived->BN.toString}`->React.string} </div>
      {switch paymentsQuery {
      | {loading: true, data: None} => <p> {"Loading"->React.string} </p>
      | {error: Some(error)} =>
        Js.log(error)
        <p> {"Data is loaded"->React.string} </p>
      | {data: Some({payments})} =>
        <div>
          {if payments->Array.length > 0 {
            <>
              <h4> {"Payment History"->React.string} </h4>
              {payments
              ->Array.map(p => {
                <div key={p.id->Js.String2.make}>
                  <hr />
                  <div> {`Payment amount: ${p.paymentAmount->BN.toString}`->React.string} </div>
                  <div> {`Payment state: ${p.paymentState}`->React.string} </div>
                  <div>
                    {`Payment timestamp: ${p.paymentTimestamp->BN.toString}`->React.string}
                  </div>
                </div>
              })
              ->React.array}
            </>
          } else {
            React.null
          }}
        </div>
      | {loading: false, data: None} => <p> {"Error loading data"->React.string} </p>
      }}
    </>
  }
}

module StreamsTable = {
  @react.component
  let make = (
    ~isOpen: bool,
    ~streamsQuery: ApolloClient__React_Hooks_UseQuery.QueryResult.t<
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.t,
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.Raw.t,
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.t_variables,
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.Raw.t_variables,
    >,
  ) => {
    let (viewingStream, setViewingStream) = React.useState(_ => false)
    let (currentStream, setCurrentStream) = React.useState(_ => None)
    React.useEffect1(() => {
      setViewingStream(_ => false)
      None
    }, [isOpen])
    <div>
      {if !viewingStream {
        switch streamsQuery {
        | {loading: true, data: None} => <p> {"Loading"->React.string} </p>
        | {error: Some(error)} =>
          Js.log(error)
          <p> {"Data is loaded"->React.string} </p>
        | {data: Some({streams})} =>
          <table id="streams">
            <tbody>
              {streams
              ->Array.map(stream => {
                <tr key={stream.id->Js.String2.make}>
                  <td> {`Stream ${stream.id->Js.String2.make}`->React.string} </td>
                  <td>
                    <button
                      onClick={_ => {
                        setViewingStream(_ => true)
                        setCurrentStream(_ => Some(stream))
                      }}>
                      {"View More Info"->React.string}
                    </button>
                  </td>
                </tr>
              })
              ->React.array}
            </tbody>
          </table>
        | {loading: false, data: None} => <p> {"Error loading data"->React.string} </p>
        }
      } else {
        <>
          <h3> {"Stream Info"->React.string} </h3>
          {switch currentStream {
          | Some(stream) => <StreamsInfo stream={stream} />
          | None => React.null
          }}
          <button onClick={_ => setViewingStream(_ => false)}> {"BACK"->React.string} </button>
        </>
      }}
    </div>
  }
}

@react.component
let make = () => {
  let user = RootProvider.useCurrentUserExn()

  let (isOpen, setIsOpen) = React.useState(_ => true)

  let viewOpenStreamsQuery = Queries.ViewPaymentsStreamsWithAddress.use({
    {address: user->Ethers.Utils.ethAdrToStr, state: "OPEN"}
  })

  let viewClosedStreamsQuery = Queries.ViewPaymentsStreamsWithAddress.use({
    {address: user->Ethers.Utils.ethAdrToStr, state: "CLOSED"}
  })

  <>
    <h2> {`${isOpen ? "OPEN" : "CLOSED"} STREAMS`->React.string} </h2>
    <button disabled={isOpen} onClick={_ => setIsOpen(_ => true)}>
      {"VIEW OPEN"->React.string}
    </button>
    <button disabled={!isOpen} onClick={_ => setIsOpen(_ => false)}>
      {"VIEW CLOSED"->React.string}
    </button>
    <StreamsTable
      streamsQuery={isOpen ? viewOpenStreamsQuery : viewClosedStreamsQuery} isOpen={isOpen}
    />
  </>
}
