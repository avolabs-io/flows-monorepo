// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReasonReactRouter from "reason-react/src/ReasonReactRouter.bs.js";

function fromUrl(url) {
  var match = url.path;
  if (!match) {
    return /* Dashboard */0;
  }
  switch (match.hd) {
    case "contacts" :
        if (match.tl) {
          return ;
        } else {
          return /* Contacts */2;
        }
    case "dev" :
        if (match.tl) {
          return ;
        } else {
          return /* Dev */4;
        }
    case "login" :
        if (match.tl) {
          return ;
        } else {
          return /* Login */3;
        }
    case "stream" :
        if (match.tl) {
          return ;
        } else {
          return /* Stream */1;
        }
    default:
      return ;
  }
}

function useRouter(param) {
  return fromUrl(ReasonReactRouter.useUrl(undefined, undefined));
}

export {
  fromUrl ,
  useRouter ,
  
}
/* ReasonReactRouter Not a pure module */
