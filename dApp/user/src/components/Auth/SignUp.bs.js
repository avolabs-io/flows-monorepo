// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Formality from "re-formality/src/Formality.bs.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Form$FlowsUserApp from "../Form.bs.js";
import * as Ethers$FlowsUserApp from "../../lib/Ethers/Ethers.bs.js";
import * as Formality__ReactUpdate from "re-formality/src/Formality__ReactUpdate.bs.js";

var validators_name = {
  strategy: /* OnFirstBlur */0,
  validate: (function (param) {
      var name = param.name;
      if (name === "") {
        return {
                TAG: /* Error */1,
                _0: "Name is required"
              };
      } else {
        return {
                TAG: /* Ok */0,
                _0: name
              };
      }
    })
};

var validators_address = {
  strategy: /* OnFirstBlur */0,
  validate: (function (param) {
      var address = param.address;
      if (address === "") {
        return {
                TAG: /* Error */1,
                _0: "Address is required"
              };
      } else {
        return Belt_Option.mapWithDefault(Ethers$FlowsUserApp.Utils.getAddress(address), {
                    TAG: /* Error */1,
                    _0: "Couldn't parse address"
                  }, (function (address) {
                      return {
                              TAG: /* Ok */0,
                              _0: address
                            };
                    }));
      }
    })
};

var validators = {
  name: validators_name,
  address: validators_address
};

function initialFieldsStatuses(_input) {
  return {
          name: /* Pristine */0,
          address: /* Pristine */0
        };
}

function initialState(input) {
  return {
          input: input,
          fieldsStatuses: {
            name: /* Pristine */0,
            address: /* Pristine */0
          },
          collectionsStatuses: undefined,
          formStatus: /* Editing */0,
          submissionStatus: /* NeverSubmitted */0
        };
}

function validateForm(input, validators, fieldsStatuses) {
  var match = fieldsStatuses.name;
  var match_0 = match ? match._0 : Curry._1(validators.name.validate, input);
  var match$1 = fieldsStatuses.address;
  var match_0$1 = match$1 ? match$1._0 : Curry._1(validators.address.validate, input);
  var nameResult = match_0;
  var nameResult$1;
  if (nameResult.TAG === /* Ok */0) {
    var addressResult = match_0$1;
    if (addressResult.TAG === /* Ok */0) {
      return {
              TAG: /* Valid */0,
              output: {
                address: addressResult._0,
                name: nameResult._0
              },
              fieldsStatuses: {
                name: /* Dirty */{
                  _0: nameResult,
                  _1: /* Shown */0
                },
                address: /* Dirty */{
                  _0: addressResult,
                  _1: /* Shown */0
                }
              },
              collectionsStatuses: undefined
            };
    }
    nameResult$1 = nameResult;
  } else {
    nameResult$1 = nameResult;
  }
  return {
          TAG: /* Invalid */1,
          fieldsStatuses: {
            name: /* Dirty */{
              _0: nameResult$1,
              _1: /* Shown */0
            },
            address: /* Dirty */{
              _0: match_0$1,
              _1: /* Shown */0
            }
          },
          collectionsStatuses: undefined
        };
}

function useForm(initialInput, onSubmit) {
  var memoizedInitialState = React.useMemo((function () {
          return initialState(initialInput);
        }), [initialInput]);
  var match = Formality__ReactUpdate.useReducer(memoizedInitialState, (function (state, action) {
          if (typeof action === "number") {
            switch (action) {
              case /* BlurNameField */0 :
                  var result = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.name, validators_name, (function (status) {
                          var init = state.fieldsStatuses;
                          return {
                                  name: status,
                                  address: init.address
                                };
                        }));
                  if (result !== undefined) {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: result,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: state.formStatus,
                              submissionStatus: state.submissionStatus
                            }
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              case /* BlurAddressField */1 :
                  var result$1 = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.address, validators_address, (function (status) {
                          var init = state.fieldsStatuses;
                          return {
                                  name: init.name,
                                  address: status
                                };
                        }));
                  if (result$1 !== undefined) {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: result$1,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: state.formStatus,
                              submissionStatus: state.submissionStatus
                            }
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              case /* Submit */2 :
                  var match = state.formStatus;
                  if (typeof match !== "number" && match.TAG === /* Submitting */0) {
                    return /* NoUpdate */0;
                  }
                  var match$1 = validateForm(state.input, validators, state.fieldsStatuses);
                  if (match$1.TAG !== /* Valid */0) {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: match$1.fieldsStatuses,
                              collectionsStatuses: match$1.collectionsStatuses,
                              formStatus: /* Editing */0,
                              submissionStatus: /* AttemptedToSubmit */1
                            }
                          };
                  }
                  var output = match$1.output;
                  var error = state.formStatus;
                  var tmp;
                  tmp = typeof error === "number" || error.TAG !== /* SubmissionFailed */1 ? undefined : Caml_option.some(error._0);
                  return {
                          TAG: /* UpdateWithSideEffects */1,
                          _0: {
                            input: state.input,
                            fieldsStatuses: match$1.fieldsStatuses,
                            collectionsStatuses: match$1.collectionsStatuses,
                            formStatus: {
                              TAG: /* Submitting */0,
                              _0: tmp
                            },
                            submissionStatus: /* AttemptedToSubmit */1
                          },
                          _1: (function (param) {
                              var dispatch = param.dispatch;
                              return Curry._2(onSubmit, output, {
                                          notifyOnSuccess: (function (input) {
                                              return Curry._1(dispatch, {
                                                          TAG: /* SetSubmittedStatus */2,
                                                          _0: input
                                                        });
                                            }),
                                          notifyOnFailure: (function (error) {
                                              return Curry._1(dispatch, {
                                                          TAG: /* SetSubmissionFailedStatus */3,
                                                          _0: error
                                                        });
                                            }),
                                          reset: (function (param) {
                                              return Curry._1(dispatch, /* Reset */5);
                                            }),
                                          dismissSubmissionResult: (function (param) {
                                              return Curry._1(dispatch, /* DismissSubmissionResult */4);
                                            })
                                        });
                            })
                        };
                  break;
              case /* DismissSubmissionError */3 :
                  var match$2 = state.formStatus;
                  if (typeof match$2 === "number" || match$2.TAG !== /* SubmissionFailed */1) {
                    return /* NoUpdate */0;
                  } else {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: state.fieldsStatuses,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Editing */0,
                              submissionStatus: state.submissionStatus
                            }
                          };
                  }
              case /* DismissSubmissionResult */4 :
                  var match$3 = state.formStatus;
                  if (typeof match$3 === "number") {
                    if (match$3 === /* Editing */0) {
                      return /* NoUpdate */0;
                    }
                    
                  } else if (match$3.TAG === /* Submitting */0) {
                    return /* NoUpdate */0;
                  }
                  return {
                          TAG: /* Update */0,
                          _0: {
                            input: state.input,
                            fieldsStatuses: state.fieldsStatuses,
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: /* Editing */0,
                            submissionStatus: state.submissionStatus
                          }
                        };
              case /* Reset */5 :
                  return {
                          TAG: /* Update */0,
                          _0: initialState(initialInput)
                        };
              
            }
          } else {
            switch (action.TAG | 0) {
              case /* UpdateNameField */0 :
                  var nextInput = Curry._1(action._0, state.input);
                  return {
                          TAG: /* Update */0,
                          _0: {
                            input: nextInput,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput, state.fieldsStatuses.name, state.submissionStatus, validators_name, (function (status) {
                                    var init = state.fieldsStatuses;
                                    return {
                                            name: status,
                                            address: init.address
                                          };
                                  })),
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: state.formStatus,
                            submissionStatus: state.submissionStatus
                          }
                        };
              case /* UpdateAddressField */1 :
                  var nextInput$1 = Curry._1(action._0, state.input);
                  return {
                          TAG: /* Update */0,
                          _0: {
                            input: nextInput$1,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput$1, state.fieldsStatuses.address, state.submissionStatus, validators_address, (function (status) {
                                    var init = state.fieldsStatuses;
                                    return {
                                            name: init.name,
                                            address: status
                                          };
                                  })),
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: state.formStatus,
                            submissionStatus: state.submissionStatus
                          }
                        };
              case /* SetSubmittedStatus */2 :
                  var input = action._0;
                  if (input !== undefined) {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: input,
                              fieldsStatuses: {
                                name: /* Pristine */0,
                                address: /* Pristine */0
                              },
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Submitted */1,
                              submissionStatus: state.submissionStatus
                            }
                          };
                  } else {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: {
                                name: /* Pristine */0,
                                address: /* Pristine */0
                              },
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Submitted */1,
                              submissionStatus: state.submissionStatus
                            }
                          };
                  }
              case /* SetSubmissionFailedStatus */3 :
                  return {
                          TAG: /* Update */0,
                          _0: {
                            input: state.input,
                            fieldsStatuses: state.fieldsStatuses,
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: {
                              TAG: /* SubmissionFailed */1,
                              _0: action._0
                            },
                            submissionStatus: state.submissionStatus
                          }
                        };
              case /* MapSubmissionError */4 :
                  var map = action._0;
                  var error$1 = state.formStatus;
                  if (typeof error$1 === "number") {
                    return /* NoUpdate */0;
                  }
                  if (error$1.TAG !== /* Submitting */0) {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: state.fieldsStatuses,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: {
                                TAG: /* SubmissionFailed */1,
                                _0: Curry._1(map, error$1._0)
                              },
                              submissionStatus: state.submissionStatus
                            }
                          };
                  }
                  var error$2 = error$1._0;
                  if (error$2 !== undefined) {
                    return {
                            TAG: /* Update */0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: state.fieldsStatuses,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: {
                                TAG: /* Submitting */0,
                                _0: Caml_option.some(Curry._1(map, Caml_option.valFromOption(error$2)))
                              },
                              submissionStatus: state.submissionStatus
                            }
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              
            }
          }
        }));
  var dispatch = match[1];
  var state = match[0];
  var match$1 = state.formStatus;
  var tmp;
  tmp = typeof match$1 === "number" || match$1.TAG !== /* Submitting */0 ? false : true;
  return {
          updateName: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: /* UpdateNameField */0,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            })
                        });
            }),
          updateAddress: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: /* UpdateAddressField */1,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            })
                        });
            }),
          blurName: (function (param) {
              return Curry._1(dispatch, /* BlurNameField */0);
            }),
          blurAddress: (function (param) {
              return Curry._1(dispatch, /* BlurAddressField */1);
            }),
          nameResult: Formality.exposeFieldResult(state.fieldsStatuses.name),
          addressResult: Formality.exposeFieldResult(state.fieldsStatuses.address),
          input: state.input,
          status: state.formStatus,
          dirty: (function (param) {
              var match = state.fieldsStatuses;
              if (match.name || match.address) {
                return true;
              } else {
                return false;
              }
            }),
          valid: (function (param) {
              var match = validateForm(state.input, validators, state.fieldsStatuses);
              if (match.TAG === /* Valid */0) {
                return true;
              } else {
                return false;
              }
            }),
          submitting: tmp,
          submit: (function (param) {
              return Curry._1(dispatch, /* Submit */2);
            }),
          dismissSubmissionError: (function (param) {
              return Curry._1(dispatch, /* DismissSubmissionError */3);
            }),
          dismissSubmissionResult: (function (param) {
              return Curry._1(dispatch, /* DismissSubmissionResult */4);
            }),
          mapSubmissionError: (function (map) {
              return Curry._1(dispatch, {
                          TAG: /* MapSubmissionError */4,
                          _0: map
                        });
            }),
          reset: (function (param) {
              return Curry._1(dispatch, /* Reset */5);
            })
        };
}

var SignUpForm = {
  validators: validators,
  initialFieldsStatuses: initialFieldsStatuses,
  initialCollectionsStatuses: undefined,
  initialState: initialState,
  validateForm: validateForm,
  useForm: useForm
};

var initialInput = {
  address: "",
  name: ""
};

function SignUp(Props) {
  var form = useForm(initialInput, (function (param, param$1) {
          console.log("NEEDS TO BE IMPLEMENTED");
          
        }));
  var match = form.addressResult;
  var tmp;
  tmp = match !== undefined && match.TAG !== /* Ok */0 ? React.createElement("div", undefined, match._0) : null;
  var match$1 = form.nameResult;
  var tmp$1;
  tmp$1 = match$1 !== undefined && match$1.TAG !== /* Ok */0 ? React.createElement("div", undefined, match$1._0) : null;
  return React.createElement(Form$FlowsUserApp.make, {
              className: "",
              onSubmit: (function (param) {
                  return Curry._1(form.submit, undefined);
                }),
              children: null
            }, React.createElement("h2", undefined, "Sign Up"), React.createElement("label", {
                  htmlFor: "address"
                }, "Raiden Address: "), React.createElement("input", {
                  id: "address",
                  disabled: form.submitting,
                  type: "text",
                  value: form.input.address,
                  onBlur: (function (param) {
                      return Curry._1(form.blurAddress, undefined);
                    }),
                  onChange: (function ($$event) {
                      return Curry._2(form.updateAddress, (function (input, value) {
                                    return {
                                            address: value,
                                            name: input.name
                                          };
                                  }), $$event.target.value);
                    })
                }), tmp, React.createElement("br", undefined), React.createElement("label", {
                  htmlFor: "name"
                }, "Name: "), React.createElement("input", {
                  id: "name",
                  disabled: form.submitting,
                  type: "text",
                  value: form.input.name,
                  onBlur: (function (param) {
                      return Curry._1(form.blurName, undefined);
                    }),
                  onChange: (function ($$event) {
                      return Curry._2(form.updateName, (function (input, value) {
                                    return {
                                            address: input.address,
                                            name: value
                                          };
                                  }), $$event.target.value);
                    })
                }), tmp$1, React.createElement("br", undefined), React.createElement("button", undefined, "Sign Up"));
}

var make = SignUp;

export {
  SignUpForm ,
  initialInput ,
  make ,
  
}
/* react Not a pure module */