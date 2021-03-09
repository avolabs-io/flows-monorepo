type loggedInStatus =  | Web3AndDb | Web3Only | @as("DbOnly") DbOnly(Ethers.ethAddress) | NotLoggedIn

let loggedInStatusToStr = (status) => switch(status){
  | Web3AndDb=>"Web3AndDb"
  | Web3Only=>"Web3Only"
  | DbOnly(_)=>"DbOnly"
  | NotLoggedIn=>"NotLoggedIn"
}


type authContextType = {
  loggedInStatus: loggedInStatus,
  setLoggedInStatus: ((loggedInStatus => loggedInStatus) => unit)
}


module AuthContext = {
  let context = React.createContext({loggedInStatus: NotLoggedIn, setLoggedInStatus: (_)=> () })

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

let getDBAuthStatus = 
  user => 
    Auth.Headers.make(~user)->Option.isSome


@react.component
let make = (~children) => {
    let user = RootProvider.useCurrentUser()

    let (loggedInStatus, setLoggedInStatus) = React.useState(_ => NotLoggedIn)

    React.useEffect1(() => {
      switch(user){
        | Some(user) => {
            Auth.LocalStorage.setCurrentUser(~ethAddress=user)
            if(user->getDBAuthStatus){
              setLoggedInStatus(_ => Web3AndDb)
            }else{
              setLoggedInStatus(_ => Web3Only)
            }
          }
        | None => {
          let userOpt = Auth.LocalStorage.getCurrentLoggedInUserOpt()
          switch(userOpt){
            | Some(user) => setLoggedInStatus(_ => DbOnly(user))
            | None => setLoggedInStatus(_ => NotLoggedIn)
          }
        }
      }
      None
    }, [user])
    

    <AuthContext.Provider value={{
      loggedInStatus,
      setLoggedInStatus
    }}>
        {children}
    </AuthContext.Provider>
}

let useAuthStatus = () => React.useContext(AuthContext.context)
