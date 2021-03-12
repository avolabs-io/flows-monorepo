module OnlyLoggedIn = {
  @react.component
  let make = (~children) => {
    let optUsersAccount = RootProvider.useCurrentUser()

    switch optUsersAccount {
    | None => <Login redirectOnLogin=false />
    | Some(_account) => children
    }
  }
}
module Main = {
  @react.component
  let make = () => {
    <OnlyLoggedIn> <h1> {"Main component"->React.string} </h1> <Dapp /> </OnlyLoggedIn>
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

module GraphQl = {
  @react.component
  let make = (~children) => {
    let user = RootProvider.useCurrentUser()
    let client = React.useMemo1(() => Apollo.makeClient(~user), [user])

    <ApolloClient.React.ApolloProvider client> children </ApolloClient.React.ApolloProvider>
  }
}
@react.component
let make = () =>
  <RootProvider> <GraphQl> <AuthProvider> <Router /> </AuthProvider> </GraphQl> </RootProvider>
