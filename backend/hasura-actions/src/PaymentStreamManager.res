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
@decco.decode
type body_in = {input: recipientData}

@decco.encode
type body_out = {
  success: bool,
  error: option<string>,
}

let createStream = Serbet.endpoint({
  verb: POST,
  path: "/create-stream",
  handler: req =>
    req.requireBody(value => {
      body_in_decode(value)
    })->Js.Promise.then_(body => {
      Js.log2("The result is", body)

      {
        Serbet.Endpoint.OkJson({success: true, error: None}->body_out_encode)
      }->Js.Promise.resolve
    }, _),
})
