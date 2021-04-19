module ViewPaymentsStreamsWithAddress = %graphql(`
  query ViewPaymentsStreamsWithAddress ($address: String!, $state: String!){
    streams(where: {recipient: {_eq: $address}, state: {_eq: $state}}){
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
  mutation CreatePaymentStream ($amount: String!, $interval: Int!, $numberOfPayments: Int!, $recipient: String!, $startPayment: Int!, $tokenAddress: String!) {
  createStream(amount: $amount, interval: $interval, numberOfPayments: $numberOfPayments, startPayment: $startPayment, tokenAddress: $tokenAddress, userAddress: $recipient){
    success
    error
  }
}
`)

module AddUser = %graphql(`
  mutation AddUser ($name: String!, $address: String!, $description: String!){
    insert_user_one(object: {name: $name, ethAddress: $address, description: $description}) {
      name
      ethAddress
      description
    }
  }
`)

module GetPaymentHistory = %graphql(`
  query GetPaymentHistory ($streamID: Int!){
    payments(where: {streamID: {_eq: $streamID}}){
      id
      paymentAmount @ppxCustom(module: "GqlConverters.IntToBigInt")
      paymentState
      paymentTimestamp @ppxCustom(module: "GqlConverters.IntToBigInt")
    }
  }
`)
