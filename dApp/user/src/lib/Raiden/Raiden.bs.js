// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_dict from "bs-platform/lib/es6/js_dict.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Ethers$FlowsUserApp from "../Ethers/Ethers.bs.js";

function transferIdentifierToStr(prim) {
  return prim;
}

function getKeysAsAddresses(dict) {
  return Object.keys(dict);
}

function tokens(t) {
  return Object.keys(t);
}

function partners(t, tokenAddress) {
  return Belt_Option.map(Js_dict.get(t, Ethers$FlowsUserApp.Utils.ethAdrToStr(tokenAddress)), (function (dict) {
                return Object.keys(dict);
              }));
}

function partnersExn(t, tokenAddress) {
  return Belt_Option.getExn(partners(t, tokenAddress));
}

var partnersUnsafe = partners;

function get(t, tokenAddress, partnerAddress) {
  return Belt_Option.flatMap(Js_dict.get(t, Ethers$FlowsUserApp.Utils.ethAdrToStr(tokenAddress)), (function (x) {
                return Js_dict.get(x, Ethers$FlowsUserApp.Utils.ethAdrToStr(partnerAddress));
              }));
}

function getExn(t, tokenAddress, partnerAddress) {
  return Belt_Option.getExn(get(t, tokenAddress, partnerAddress));
}

var getUnsafe = get;

var Channels = {
  getKeysAsAddresses: getKeysAsAddresses,
  tokens: tokens,
  partners: partners,
  partnersExn: partnersExn,
  partnersUnsafe: partnersUnsafe,
  get: get,
  getExn: getExn,
  getUnsafe: getUnsafe
};

function transferIdentifiers(t) {
  return Object.keys(t);
}

var get$1 = Js_dict.get;

function getExn$1(t, transferIdentifier) {
  return Belt_Option.getExn(Js_dict.get(t, transferIdentifier));
}

var getUnsafe$1 = Js_dict.get;

var Transfers = {
  transferIdentifiers: transferIdentifiers,
  get: get$1,
  getExn: getExn$1,
  getUnsafe: getUnsafe$1
};

export {
  transferIdentifierToStr ,
  Channels ,
  Transfers ,
  
}
/* Ethers-FlowsUserApp Not a pure module */
