// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Client from "@apollo/client";
import * as Apollo$ViteReasonReact from "./Apollo.bs.js";
import * as TestQuery$ViteReasonReact from "./TestQuery.bs.js";

function App(Props) {
  return React.createElement(Client.ApolloProvider, {
              client: Apollo$ViteReasonReact.client,
              children: React.createElement(TestQuery$ViteReasonReact.make, {})
            });
}

var make = App;

export {
  make ,
  
}
/* react Not a pure module */
