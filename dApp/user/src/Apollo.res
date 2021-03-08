let graphqlEndpoint = "localhost:8080/v1/graphql"

let headers = {"x-hasura-admin-secret": "testing"}


type clientHeaders = {
    @as("eth-address")
    ethAddress: string,
    @as("eth-signature")
    ethSignature: string,
}

let getAuthHeaders = (~user) => {
  open Ethers.Utils
    switch(user){
      | None => None
      | Some(u) => {
          let getUserSignature = Dom.Storage2.getItem(_, u->ethAdrToLowerStr)
          switch(getUserSignature(Dom.Storage2.localStorage)){
            | None => None
            | Some(uS) => Some({ethAddress: u->ethAdrToStr, ethSignature: uS})
          }
      }
    }
}

let httpLink = ApolloClient.Link.HttpLink.make(
  ~uri=_ => "http://" ++ graphqlEndpoint,
  ~headers=Obj.magic(headers),
  (),
)

let makeHttpLink = (~user) => ApolloClient.Link.HttpLink.make(
    ~uri= _ => "http://" ++ graphqlEndpoint, 
    ~headers={
    switch(getAuthHeaders(~user)){
      | Some(headers) => headers->Obj.magic
      | None => Js.Obj.empty->Obj.magic
    }
}, ())

let wsLink = {
  open ApolloClient.Link.WebSocketLink
  make(
    ~uri="ws://" ++ graphqlEndpoint,
    ~options=ClientOptions.make(
      ~connectionParams=ConnectionParams(Obj.magic({"headers": headers})),
      ~reconnect=true,
      (),
    ),
    (),
  )
}

let terminatingLink = (~user) => ApolloClient.Link.split(~test=({query}) => {
  let definition = ApolloClient.Utilities.getOperationDefinition(query)
  switch definition {
  | Some({kind, operation}) => kind === "OperationDefinition" && operation === "subscription"
  | None => false
  }
}, ~whenTrue=wsLink, ~whenFalse=makeHttpLink(~user))

let makeClient = (~user) => {
  open ApolloClient
  make(
    ~cache=Cache.InMemoryCache.make(),
    ~connectToDevTools=true,
    ~defaultOptions=DefaultOptions.make(
      ~mutate=DefaultMutateOptions.make(~awaitRefetchQueries=true, ~errorPolicy=All, ()),
      ~query=DefaultQueryOptions.make(~fetchPolicy=NetworkOnly, ~errorPolicy=All, ()),
      ~watchQuery=DefaultWatchQueryOptions.make(~fetchPolicy=NetworkOnly, ~errorPolicy=All, ()),
      (),
    ),
    ~link=terminatingLink(~user),
    (),
  )
}
