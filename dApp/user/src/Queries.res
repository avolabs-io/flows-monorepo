module ViewPaymentsStreamsWithAddress = %graphql(`
  query ViewPaymentsStreamsWithAddress ($address: String!){
    streams(where: {recipient: {_eq: $address}}){
      id
      amount @ppxCustom(module: "GqlConverters.BigInt")
      interval @ppxCustom(module: "GqlConverters.IntToBigInt")
      numberOfPayments @ppxCustom(module: "GqlConverters.IntToBigInt")
      numberOfPaymentsMade @ppxCustom(module: "GqlConverters.IntToBigInt")
      recipient
      state
      tokenAddress
      startPayment @ppxCustom(module: "GqlConverters.IntToBigInt")
      nextPayment @ppxCustom(module: "GqlConverters.IntToBigInt")
      lastPayment
    }
  }
`)

module CreatePaymentStream = %graphql(`
  mutation CreatePaymentStream ($amount: String!, $interval: Int!, $numberOfPayments: Int!, $recipient: String!, $startPayment: Int!, $state: String, $tokenAddress: String!) {
    insert_streams_one(object: {amount: $amount, interval: $interval, numberOfPayments: $numberOfPayments, numberOfPaymentsMade: 0, recipient: $recipient, startPayment: $startPayment, state: $state, tokenAddress: $tokenAddress}) {
      id
    }
  }
`)
