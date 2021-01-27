module Main = {
  @react.component
  let make = () => {
    <h1> {"Main component"->React.string} </h1>
  }
}
module NotFound = {
  @react.component
  let make = () => {
    <h1> {"Not Found - 404"->React.string} </h1>
  }
}

module Router = {
  @react.component
  let make = () => {
    let route = Router.useRouter()

    switch route {
    | Some(Main) => <Main />
    | Some(Login) => <Login />
    | None => <NotFound />
    }
  }
}
@react.component
let make = () =>
  <ApolloClient.React.ApolloProvider client=Apollo.client>
    <Router />
  </ApolloClient.React.ApolloProvider>
