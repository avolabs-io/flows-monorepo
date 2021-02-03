// File to put all GQL Queries.
// open GqlConverters;

module CreatePaymentStream = %graphql(`
  mutation CreatePayment ($amount: String!, $interval: Int!, $numberOfPayments: Int!, $recipient: String!, $start: Int!, $state: String, $tokenAddress: String!) {
    insert_streams_one(object: {amount: $amount, interval: $interval, numberOfPayments: $numberOfPayments, numberOfPaymentsMade: 0, recipient: $recipient, start: $start, state: $state, tokenAddress: $tokenAddress}) {
      id
    }
  }
`)

module GetStreamData = %graphql(`
  query {
    streams(where: {state: {_eq: "OPEN"}}) {
      id
      amount
      interval
      numberOfPayments
      numberOfPaymentsMade
      recipient
      start
      state
      tokenAddress
      paymentTick
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
  mutation UpdateStreamEntry ($id: Int!, $paymentsMade: Int!, $paymentTick: Int!){
    update_streams_by_pk(pk_columns: {id: $id}, _set: {numberOfPaymentsMade: $paymentsMade, paymentTick: $paymentTick}) {
      id
      numberOfPaymentsMade
      paymentTick
    }
  }
`)

module DeleteStreamEntry = %graphql(`
  mutation DeleteStreamEntry ($id: Int!){
    delete_streams_by_pk(id: $id) {
      id
    }
  }
`)
