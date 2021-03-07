module ApolloQueryResult = ApolloClient.Types.ApolloQueryResult

@decco.decode
type recipientData = {
  recipient: string,
  addressTokenStream: string,
  lengthOfPayment: int,
  interval: int,
  // TODO: these values should be BigInt and use `@decco.codec` as the conversion function
  rate: string,
  deposit: string,
}
@decco.decode
type body_in = {input: recipientData}

@decco.encode
type body_out = {
  success: bool,
  error: option<string>,
  // depositTxHash: string
}

let gqlClient = ClientConfig.createInstance(
  ~headers={"x-hasura-admin-secret": "testing"},
  ~graphqlEndpoint="http://graphql-engine:8080/v1/graphql",
  (),
)

let createStream = Serbet.endpoint({
  verb: POST,
  path: "/create-stream",
  handler: req =>
    req.requireBody(value => {
      body_in_decode(value)
    })->JsPromise.then(({
      input: {recipient, addressTokenStream, lengthOfPayment, interval, rate, deposit},
    }) => {
      Js.log(`TODO: we must still make the deposit here ${deposit}`)

      gqlClient.mutate(
        ~mutation=module(Query.CreatePaymentStream),
        Query.CreatePaymentStream.makeVariables(
          ~amount=rate,
          ~interval,
          ~numberOfPayments=lengthOfPayment,
          ~recipient,
          ~start=1,
          ~state="TODO: Pending DepositCreation",
          ~tokenAddress=addressTokenStream,
          (),
        ),
      )->JsPromise.map(result =>
        switch result {
        | Ok(_result) => {success: true, error: None}
        | Error(error) =>
          let {message}: ApolloClient__ApolloClient.ApolloError.t = error
          {
            success: false,
            error: Some(message),
          }
        }
        ->body_out_encode
        ->Serbet.Endpoint.OkJson
      )
    }),
})

let addPaymentEntry = (~streamID, ~timestamp, ~amount) => {
  gqlClient.mutate(
    ~mutation=module(Query.AddPaymentEntry),
    Query.AddPaymentEntry.makeVariables(
      ~streamID,
      ~paymentTimestamp=timestamp,
      ~paymentState="PENDING",
      ~paymentAmount=amount,
      (),
    ),
  )
  ->JsPromise.map(result =>
    switch result {
    | Ok({data}) => Js.log2("success payment added", data.insert_payments_one)
    | Error(error) => Js.log2("error payment added: ", error)
    }
  )
  ->ignore
}

let updatePaymentEntry = (~paymentID, ~state) => {
  gqlClient.mutate(
    ~mutation=module(Query.UpdatePaymentEntry),
    Query.UpdatePaymentEntry.makeVariables(~paymentID, ~paymentState=state, ()),
  )
  ->JsPromise.map(result =>
    switch result {
    | Ok(_result) => Js.log2("success update payment: ", state)
    | Error(error) => Js.log3("error update payment: ", state, error)
    }
  )
  ->ignore
}

let updateStreamEntry = (~streamID, ~totalPaymentsMade, ~nextPayment, ~lastPayment) => {
  gqlClient.mutate(
    ~mutation=module(Query.UpdateStreamEntry),
    Query.UpdateStreamEntry.makeVariables(
      ~id=streamID,
      ~paymentsMade=totalPaymentsMade,
      ~nextPayment,
      ~lastPayment,
      (),
    ),
  )
  ->JsPromise.map(result =>
    switch result {
    | Ok(_result) => Js.log3("success payment made: ", totalPaymentsMade, nextPayment)
    | Error(error) => Js.log2("error payment made: ", error)
    }
  )
  ->ignore
}

let closeStreamEntry = (~streamID, ~totalPaymentsMade) => {
  gqlClient.mutate(
    ~mutation=module(Query.CloseStreamEntry),
    Query.CloseStreamEntry.makeVariables(
      ~id=streamID,
      ~paymentsMade=totalPaymentsMade,
      ~state="CLOSED",
      (),
    ),
  )
  ->JsPromise.map(result =>
    switch result {
    | Ok(_result) => Js.log("success close entry: CLOSED")
    | Error(error) => Js.log2("error close entry: ", error)
    }
  )
  ->ignore
}

let addUser = (~username, ~ethAddress, ~description) => {
  gqlClient.mutate(
    ~mutation=module(Query.AddUser),
    Query.AddUser.makeVariables(~name=username, ~address=ethAddress, ~description, ()),
  )
  ->JsPromise.map(result =>
    switch result {
    | Ok(_result) => Js.log("success user added")
    | Error(error) => Js.log2("error user added: ", error)
    }
  )
  ->ignore
}
