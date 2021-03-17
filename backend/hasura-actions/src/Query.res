// File to put all GQL Queries.
// open GqlConverters;

module AddUser = %graphql(`
  mutation AddUser ($name: String!, $address: String!, $description: String!){
    insert_user_one(object: {name: $name, ethAddress: $address, description: $description}) {
      name
      ethAddress
      description
    }
  }
`)

module ViewPaymentStreams = %graphql(`
  query ViewPaymentStreams ($state: String!){
    streams(where: {state: {_eq: $state}}){
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
  mutation CreatePaymentStream ($amount: String!, $interval: Int!, $numberOfPayments: Int!, $recipient: String!, $startPayment: Int!, $state: String, $tokenAddress: String!, $nextPayment: Int!) {
    insert_streams_one(object: {amount: $amount, interval: $interval, numberOfPayments: $numberOfPayments, numberOfPaymentsMade: 0, recipient: $recipient, startPayment: $startPayment, nextPayment: $nextPayment, state: $state, tokenAddress: $tokenAddress}) {
      id
    }
  }
`)

module GetStreamData = %graphql(`
  query GetStreamData ($currentTimestamp: Int!){
    streams(where: {state: {_eq: "OPEN"}, nextPayment: {_lte: $currentTimestamp}}){
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

module CloseStreamEntry = %graphql(`
  mutation CloseStreamEntry ($id: Int!, $paymentsMade: Int!, $state: String!){
    update_streams_by_pk(pk_columns: {id: $id}, _set: {numberOfPaymentsMade: $paymentsMade, state: $state}) {
      id
      state
    }
  }
`)

module UpdateStreamEntry = %graphql(`
  mutation UpdateStreamEntry ($id: Int!, $paymentsMade: Int!, $nextPayment: Int!, $lastPayment: Int!){
    update_streams_by_pk(pk_columns: {id: $id}, _set: {numberOfPaymentsMade: $paymentsMade, nextPayment: $nextPayment, lastPayment: $lastPayment}) {
      id
      numberOfPaymentsMade
      nextPayment
      lastPayment
    }
  }
`)

module AddPaymentEntry = %graphql(`
  mutation AddPaymentEntry ($streamID: Int!, $paymentTimestamp: Int!, $paymentState: payment_states_enum!, $paymentAmount: String!){
    insert_payments_one(object: {streamID: $streamID, paymentTimestamp: $paymentTimestamp, paymentState: $paymentState, paymentAmount: $paymentAmount}) {
      id
    }
  }
`)

module UpdatePaymentEntry = %graphql(`
  mutation UpdatePaymentEntry ($paymentID: Int!, $paymentState: payment_states_enum!){
    update_payments_by_pk(pk_columns: {id: $paymentID}, _set: {paymentState: $paymentState}) {
      id
      paymentState
    }
  }
`)

module GetLatestPayment = %graphql(`
  query GetLatestPayment ($streamID: Int!, $lastPayment: Int!){
    payments(where: {streamID: {_eq: $streamID}, paymentTimestamp: {_eq: $lastPayment}}){
      id
      paymentAmount
      paymentState
      paymentTimestamp @ppxCustom(module: "GqlConverters.IntToBigInt")
      streamID
    }
  }
`)
