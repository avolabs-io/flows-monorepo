type injectedType = {isAuthorized: unit => JsPromise.t<bool>}

@module("./connectors") external injected: injectedType = "injected"
