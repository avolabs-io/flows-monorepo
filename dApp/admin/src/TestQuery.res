module UserQuery = %graphql(`
query ($usersName: String!) {
  user (where: {name: {_eq: $usersName}}) {
    description
    ethAddress
    name
  }
}`)

@react.component
let make = () => {
  let queryResult = UserQuery.use(UserQuery.makeVariables(~usersName="Jason", ()))

  <div>
    {switch queryResult {
    | {loading: true, data: None} => <p> {"Loading"->React.string} </p>
    | {error: Some(error)} =>
      Js.log(error)
      <p> {"Data is loaded"->React.string} </p>
    | {data: Some({user})} =>
      switch user[0] {
      | Some({name, ethAddress}) =>
        <p>
          {`Users is loaded their name is ${name}, with this eth address ${ethAddress}`->React.string}
        </p>
      | None => <p> {"Data loaded, none found"->React.string} </p>
      }
    | {loading: false, data: None} => <p> {"Error loading data"->React.string} </p>
    }}
  </div>
}
