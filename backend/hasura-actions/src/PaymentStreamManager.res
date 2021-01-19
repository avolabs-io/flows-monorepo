@decco.decode
type recipientData = {
  recipient: string,
  addressTokenStream: string,
  lengthOfPayment: int,
  interval: int,
  // TODO: these values should be BigInt and use `@decco.codec` as the conversion function
  rate: string,
  deposit: string,
}
@decco.encode
type body_out = {
  success: bool,
  error: option<string>,
}

let createStream = Serbet.endpoint({
  verb: POST,
  path: "/icap-reward-breakdown",
  handler: req => req.requireBody(recipientData_decode)->Js.Promise.then_(body => {
      Js.log2("the body is:", body)
      {
        open Serbet.Endpoint
        OkJson({success: true, error: None}->body_out_encode)
      }->Js.Promise.resolve
    }, _),
})
