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
    open AuthProvider
    let {loggedInStatus} = useAuthStatus()
    <>
      <h3> {"Auth Status"->React.string} </h3>
      <div> {loggedInStatus->loggedInStatusToStr->React.string} </div>
      <OnlyLoggedIn> <h1> {"Main component"->React.string} </h1> <Dapp /> </OnlyLoggedIn>
    </>
  }
}

module Streams = {
  @react.component
  let make = () => {
    <OnlyLoggedIn> <ViewStreams /> </OnlyLoggedIn>
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
    let optWeb3User = RootProvider.useCurrentUser()
    let {loggedInStatus} = AuthProvider.useAuthStatus()
    let optDbOnlyUser = switch loggedInStatus {
    | DbOnly(user) => Some(user)
    | _ => None
    }

    let optUser = if Option.isSome(optWeb3User) {
      optWeb3User
    } else if Option.isSome(optDbOnlyUser) {
      optDbOnlyUser
    } else {
      None
    }

    let client = React.useMemo1(() => Apollo.makeClient(~user=optUser), [optUser])

    <ApolloClient.React.ApolloProvider client> children </ApolloClient.React.ApolloProvider>
  }
}
@react.component
let make = () =>
  <RootProvider> <AuthProvider> <GraphQl> <Router /> </GraphQl> </AuthProvider> </RootProvider>
