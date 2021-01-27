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
    })->Js.Promise.then_(
      ({input: {recipient, addressTokenStream, lengthOfPayment, interval, rate, deposit}}) => {
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
        )->Js.Promise.then_(result =>
          Js.Promise.resolve(
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
            ->Serbet.Endpoint.OkJson,
          )
        , _)
      },
      _,
    ),
})
