module UserQuery = %graphql(`
query ($usersName: String!) {
  user (where: {name: {_eq: $usersName}}) {
    description
    ethAddress
    name
  }
}`)

let wynOptionMap = (optionalValue, functionThatProcessesData) => {
  switch optionalValue {
  | Some(actualValue) => Some(actualValue->functionThatProcessesData)
  | None => None
  }
}
let multiplyBy5IfExists = optionalNumber => {
  wynOptionMap(optionalNumber, value => value->string_of_int ++ "is the value")
}

Js.log2("1", multiplyBy5IfExists(None))

Js.log2("2", multiplyBy5IfExists(Some(1)))

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
