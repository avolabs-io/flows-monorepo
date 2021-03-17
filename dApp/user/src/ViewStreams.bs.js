// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Ethers$FlowsUserApp from "./lib/Ethers/Ethers.bs.js";
import * as Queries$FlowsUserApp from "./Queries.bs.js";
import * as RootProvider$FlowsUserApp from "./lib/Old/RootProvider.bs.js";

function ViewStreams$StreamsInfo(Props) {
  var stream = Props.stream;
  var numberOfPaymentsMade = stream.numberOfPaymentsMade;
  var amount = stream.amount;
  var paymentsQuery = Curry.app(Queries$FlowsUserApp.GetPaymentHistory.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          streamID: stream.id
        }
      ]);
  var paymentsLeft = stream.numberOfPayments.sub(numberOfPaymentsMade);
  var amountReceived = amount.mul(numberOfPaymentsMade);
  var match = paymentsQuery.data;
  var tmp;
  var exit = 0;
  if (match !== undefined || !paymentsQuery.loading) {
    exit = 1;
  } else {
    tmp = React.createElement("p", undefined, "Loading");
  }
  if (exit === 1) {
    var error = paymentsQuery.error;
    if (error !== undefined) {
      console.log(error);
      tmp = React.createElement("p", undefined, "Data is loaded");
    } else if (match !== undefined) {
      var payments = match.payments;
      tmp = React.createElement("div", undefined, payments.length !== 0 ? React.createElement(React.Fragment, undefined, React.createElement("h4", undefined, "Payment History"), Belt_Array.map(payments, (function (p) {
                        return React.createElement("div", {
                                    key: String(p.id)
                                  }, React.createElement("hr", undefined), React.createElement("div", undefined, "Payment amount: " + p.paymentAmount.toString()), React.createElement("div", undefined, "Payment state: " + p.paymentState), React.createElement("div", undefined, "Payment timestamp: " + p.paymentTimestamp.toString()));
                      }))) : null);
    } else {
      tmp = React.createElement("p", undefined, "Error loading data");
    }
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, "Payment amount: " + amount.toString()), React.createElement("div", undefined, "Payments left: " + paymentsLeft.toString()), React.createElement("div", undefined, "Payments made: " + numberOfPaymentsMade.toString()), React.createElement("div", undefined, "Amount Recieved: " + amountReceived.toString()), tmp);
}

var StreamsInfo = {
  make: ViewStreams$StreamsInfo
};

function ViewStreams$StreamsTable(Props) {
  var isOpen = Props.isOpen;
  var streamsQuery = Props.streamsQuery;
  var match = React.useState(function () {
        return false;
      });
  var setViewingStream = match[1];
  var match$1 = React.useState(function () {
        
      });
  var setCurrentStream = match$1[1];
  var currentStream = match$1[0];
  React.useEffect((function () {
          Curry._1(setViewingStream, (function (param) {
                  return false;
                }));
          
        }), [isOpen]);
  var tmp;
  if (match[0]) {
    tmp = React.createElement(React.Fragment, undefined, React.createElement("h3", undefined, "Stream Info"), currentStream !== undefined ? React.createElement(ViewStreams$StreamsInfo, {
                stream: currentStream
              }) : null, React.createElement("button", {
              onClick: (function (param) {
                  return Curry._1(setViewingStream, (function (param) {
                                return false;
                              }));
                })
            }, "BACK"));
  } else {
    var match$2 = streamsQuery.data;
    var exit = 0;
    if (match$2 !== undefined || !streamsQuery.loading) {
      exit = 1;
    } else {
      tmp = React.createElement("p", undefined, "Loading");
    }
    if (exit === 1) {
      var error = streamsQuery.error;
      if (error !== undefined) {
        console.log(error);
        tmp = React.createElement("p", undefined, "Data is loaded");
      } else {
        tmp = match$2 !== undefined ? React.createElement("table", {
                id: "streams"
              }, React.createElement("tbody", undefined, Belt_Array.map(match$2.streams, (function (stream) {
                          return React.createElement("tr", {
                                      key: String(stream.id)
                                    }, React.createElement("td", undefined, "Stream " + String(stream.id)), React.createElement("td", undefined, React.createElement("button", {
                                              onClick: (function (param) {
                                                  Curry._1(setViewingStream, (function (param) {
                                                          return true;
                                                        }));
                                                  return Curry._1(setCurrentStream, (function (param) {
                                                                return stream;
                                                              }));
                                                })
                                            }, "View More Info")));
                        })))) : React.createElement("p", undefined, "Error loading data");
      }
    }
    
  }
  return React.createElement("div", undefined, tmp);
}

var StreamsTable = {
  make: ViewStreams$StreamsTable
};

function ViewStreams(Props) {
  var user = RootProvider$FlowsUserApp.useCurrentUserExn(undefined);
  var match = React.useState(function () {
        return true;
      });
  var setIsOpen = match[1];
  var isOpen = match[0];
  var viewOpenStreamsQuery = Curry.app(Queries$FlowsUserApp.ViewPaymentsStreamsWithAddress.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          address: Ethers$FlowsUserApp.Utils.ethAdrToStr(user),
          state: "OPEN"
        }
      ]);
  var viewClosedStreamsQuery = Curry.app(Queries$FlowsUserApp.ViewPaymentsStreamsWithAddress.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          address: Ethers$FlowsUserApp.Utils.ethAdrToStr(user),
          state: "CLOSED"
        }
      ]);
  return React.createElement(React.Fragment, undefined, React.createElement("h2", undefined, (
                  isOpen ? "OPEN" : "CLOSED"
                ) + " STREAMS"), React.createElement("button", {
                  disabled: isOpen,
                  onClick: (function (param) {
                      return Curry._1(setIsOpen, (function (param) {
                                    return true;
                                  }));
                    })
                }, "VIEW OPEN"), React.createElement("button", {
                  disabled: !isOpen,
                  onClick: (function (param) {
                      return Curry._1(setIsOpen, (function (param) {
                                    return false;
                                  }));
                    })
                }, "VIEW CLOSED"), React.createElement(ViewStreams$StreamsTable, {
                  isOpen: isOpen,
                  streamsQuery: isOpen ? viewOpenStreamsQuery : viewClosedStreamsQuery
                }));
}

var make = ViewStreams;

export {
  StreamsInfo ,
  StreamsTable ,
  make ,
  
}
/* react Not a pure module */
