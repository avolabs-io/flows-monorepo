// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Web3 = require("web3");
var Serbet = require("serbet/src/Serbet.bs.js");

function validateEthSignature(ethSignature, ethAddress) {
  var web3 = new Web3();
  var signersAddress = web3.eth.accounts.recover("flows.finance-signin-string:" + ethAddress, ethSignature);
  return signersAddress === ethAddress;
}

var getAuthHeaders = ((req) => req.body);

var getJwt = ((req) => req.jwt);

function authResponseToJson(prim) {
  return prim;
}

var endpoint = Serbet.endpoint(undefined, {
      path: "/auth",
      verb: /* POST */1,
      handler: (function (req) {
          var match = getAuthHeaders(req.req);
          var match$1 = match.headers;
          var ethAddress = match$1["eth-address"];
          var ethSignature = match$1["eth-signature"];
          if (ethSignature !== undefined && ethAddress !== undefined) {
            console.log("Signing in with " + ethSignature + " and " + ethAddress);
            if (validateEthSignature(ethSignature, ethAddress)) {
              return Promise.resolve({
                          TAG: /* OkJson */4,
                          _0: {
                            "X-Hasura-User-Id": ethAddress,
                            "X-Hasura-Role": "user"
                          }
                        });
            } else {
              return Promise.resolve({
                          TAG: /* Unauthorized */2,
                          _0: ""
                        });
            }
          }
          console.log("the login details aren't provided using public");
          return Promise.resolve({
                      TAG: /* OkJson */4,
                      _0: {
                        "X-Hasura-User-Id": undefined,
                        "X-Hasura-Role": "public"
                      }
                    });
        })
    });

exports.validateEthSignature = validateEthSignature;
exports.getAuthHeaders = getAuthHeaders;
exports.getJwt = getJwt;
exports.authResponseToJson = authResponseToJson;
exports.endpoint = endpoint;
/* endpoint Not a pure module */
