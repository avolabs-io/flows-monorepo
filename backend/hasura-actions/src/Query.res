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
  streams {
    amount
    interval
    numberOfPayments
    numberOfPaymentsMade
    recipient
    start
    state
    tokenAddress
  }
}
`)
