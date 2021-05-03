// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Caml_exceptions from "bs-platform/lib/es6/caml_exceptions.js";

var JsError = /* @__PURE__ */Caml_exceptions.create("JsPromise-FlowsUserApp.JsError");

function $$catch(promise, callback) {
  return promise.catch(function (err) {
              return Curry._1(callback, Caml_exceptions.caml_is_extension(err) ? err : ({
                              RE_EXN_ID: JsError,
                              _1: err
                            }));
            });
}

export {
  JsError ,
  $$catch ,
  
}
/* No side effect */