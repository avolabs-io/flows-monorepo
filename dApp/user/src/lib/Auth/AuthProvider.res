type authContextType = {
  isAuthorized: bool,
  setIsAuthorized: ((bool => bool) => unit)
}

module AuthContext = {
  let context = React.createContext({isAuthorized: false, setIsAuthorized: (_)=> () })

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

let getUserAuthStatus = (user) => Apollo.getAuthHeaders(~user)->Option.isSome

@react.component
let make = (~children) => {
    let user = RootProvider.useCurrentUser()

    let (isAuthorized, setIsAuthorized) = React.useState(_ => false)

    React.useEffect1(() => {
      let _ = setIsAuthorized(_ => user->getUserAuthStatus)
      None
    }, [user])
    

    <AuthContext.Provider value={{
      isAuthorized,
      setIsAuthorized: setIsAuthorized
    }}>
        {children}
    </AuthContext.Provider>
}

let useAuthStatus = () => React.useContext(AuthContext.context)