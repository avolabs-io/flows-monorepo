// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Heading$FlowsUserApp from "../components/Heading.bs.js";
import * as AddContact$FlowsUserApp from "../components/AddContact.bs.js";
import * as ContactsTable$FlowsUserApp from "../components/ContactsTable.bs.js";

function Contacts(Props) {
  var match = React.useState(function () {
        return false;
      });
  var setAddContact = match[1];
  return React.createElement("div", {
              className: "container max-w-3xl mx-auto"
            }, match[0] ? React.createElement(AddContact$FlowsUserApp.make, {
                    openModal: setAddContact
                  }) : null, React.createElement("div", {
                  className: "flex justify-between"
                }, React.createElement(Heading$FlowsUserApp.make, {
                      children: "Contacts"
                    }), React.createElement("button", {
                      className: "mt-3 w-full inline-flex justify-center border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm",
                      onClick: (function (param) {
                          return Curry._1(setAddContact, (function (param) {
                                        return true;
                                      }));
                        })
                    }, "Add contact")), React.createElement(ContactsTable$FlowsUserApp.make, {}));
}

var make = Contacts;

export {
  make ,
  
}
/* react Not a pure module */
