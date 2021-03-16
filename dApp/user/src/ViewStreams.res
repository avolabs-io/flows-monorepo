module StreamsTable = {
  @react.component
  let make = (
    ~streamsQuery: ApolloClient__React_Hooks_UseQuery.QueryResult.t<
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.t,
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.Raw.t,
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.t_variables,
      FlowsUserApp.Queries.ViewPaymentsStreamsWithAddress.ViewPaymentsStreamsWithAddress_inner.Raw.t_variables,
    >,
  ) => {
    let (viewingStream, setViewingStream) = React.useState(_ => false)
    let (currentStream, setCurrentStream) = React.useState(_ => None)
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
          <h1> {"Viewing Stream"->React.string} </h1>
          {switch currentStream {
          | Some(s) => s.recipient->Js.String2.make->React.string
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
    <StreamsTable streamsQuery={isOpen ? viewOpenStreamsQuery : viewClosedStreamsQuery} />
  </>
}
