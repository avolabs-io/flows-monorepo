@react.component
let make = () =>
  <ApolloClient.React.ApolloProvider client=Apollo.client>
    <TestQuery />
  </ApolloClient.React.ApolloProvider>
