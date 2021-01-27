// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Serbet = require("serbet/src/Serbet.bs.js");
var Dotenv = require("dotenv");
var AuthHook = require("./AuthHook.bs.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");
var Belt_Option = require("bs-platform/lib/js/belt_Option.js");
var PaymentStreamManager = require("./PaymentStreamManager.bs.js");

Dotenv.config();

var app = Serbet.application(Belt_Option.getWithDefault(Belt_Option.flatMap(process.env.PORT, Pervasives.int_of_string_opt), 9898), {
      hd: PaymentStreamManager.createStream,
      tl: {
        hd: AuthHook.endpoint,
        tl: /* [] */0
      }
    });

exports.app = app;
/*  Not a pure module */
