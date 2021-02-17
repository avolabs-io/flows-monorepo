open BsCron

@decco.encode
type makePaymentRequest = {
  amount: string,
  identifier: option<string>,
}
/*
KEPT THIS AS A REMINDER FOR THE DEPOSIT
let dummyData = [
  {
    recipient: "0xc788F08a2aAf539111e2a2D85BD4B324FBE37B15",
    addressTokenStream: "0xb38981469B7235c42DDa836295bE8825Eb4A6389",
    lengthOfPayment: 86400, // seconds [86400 equals one day.] Must be a multiple of 60
    interval: 60, // this will always be 60 for our demo
    // TODO: these values should be BigInt and use `@decco.codec` as the conversion function
    rate: "1",
    deposit: "7200",
    numerOfPaymentsMade: 0,
    totalNumberOfPaymentsToMake: 1440,
  },
  {
    recipient: "0xc788F08a2aAf539111e2a2D85BD4B324FBE37B15",
    addressTokenStream: "0xb38981469B7235c42DDa836295bE8825Eb4A6389",
    lengthOfPayment: 86400, // seconds [86400 equals one day.] Must be a multiple of 60
    interval: 60, // this will always be 60 for our demo
    // TODO: these values should be BigInt and use `@decco.codec` as the conversion function
    rate: "1",
    deposit: "14400",
    numerOfPaymentsMade: 0,
    totalNumberOfPaymentsToMake: 1440,
  },
|];
*/

let makePayment = (~recipientAddress, ~amount, ~streamID, ~currentPayment) => {
  Js.log("making payment")
  PaymentStreamManager.gqlClient.mutate(
    ~mutation=module(Query.AddNewPayment),
    Query.AddNewPayment.makeVariables(
      ~streamID,
      ~paymentTimestamp=currentPayment->BN.toNumber,
      ~paymentState="PENDING",
      ~paymentAmount=amount,
      (),
    ),
  )
  ->JsPromise.map(result =>
    switch result {
    | Ok(_result) => Js.log("success payment added")
    | Error(error) => Js.log2("error payment added: ", error)
    }
  )
  ->ignore
  /* let requestString =
    "http://raiden1:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/" ++
    recipientAddress
  Js.log2(requestString, amount)
  Fetch.fetchWithInit(
    requestString,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(
        {amount: amount->BN.toString, identifier: None}
        ->makePaymentRequest_encode
        ->Js.Json.stringify,
      ),
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
      (),
    ),
  )
  ->JsPromise.then(Fetch.Response.json)
  ->JsPromise.map(json => {
    Js.log2("THE RESULT:", json)
  })*/
}

/*
curl -X POST --data-raw '{"amount": "100000000000000000"}' http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92

--data-raw '{"amount":"10000000000000000000","identifier":"1612189154951"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: application/json, text/plain, *' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/json' -H 'Origin: http://localhost:5001' -H 'Connection: keep-alive' -H 'Referer: http://localhost:5001/ui/home' --data-raw '{"amount":"10000000000000000000","identifier":"1612189154951"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'Content-Type: application/json' --data-raw '{"amount":"100000000000000000","identifier":"86"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'Content-Type: application/json' --data '{"amount":"100000000000000000","identifier":"86"}'
*/

/*
USEFUL INFO
TokenAddress: 0xC563388e2e2fdD422166eD5E76971D11eD37A466
RecipientAddress: 0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92
Amount = 100000000000000000
*/

/*
nextPaymentTimestamp = 120, currentPaymentTimestamp = 600, interval = 2
600 - 120 = 480 / 2 = 240 / 60 = 4
*/

let getTimestamp = date => {
  (date->Js.Date.getTime /. 1000.0)->Int.fromFloat
}

let fromTimeStampToDate = timestamp => {
  (timestamp->Float.fromInt *. 1000.0)->Js.Date.fromFloat
}

let getCurrentTimestamp = () => {
  Js.Date.make()->getTimestamp
}

let startProcess = () => {
  let now = getCurrentTimestamp()
  Js.log2("start timestamp:", now)
  let job = CronJob.make(
    #CronString("* * * * *"), // every minute
    _ => {
      let currentTimestamp = getCurrentTimestamp()
      Js.log2("current timestamp:", currentTimestamp)
      PaymentStreamManager.gqlClient.query(
        ~query=module(Query.GetStreamData),
        Query.GetStreamData.makeVariables(~currentTimestamp, ()),
      )
      ->JsPromise.map(result =>
        switch result {
        | Ok({data: {streams}}) =>
          Js.log2("payment streams in focus:", streams)
          let _ = Array.map(streams, stream => {
            let userId = stream.id
            let recipient = stream.recipient
            let amount = stream.amount
            let nextPayment = stream.nextPayment
            let lastPayment = stream.lastPayment
            let interval = stream.interval
            let numberOfPayments = stream.numberOfPayments
            let numberOfPaymentsMade = stream.numberOfPaymentsMade
            let currentPayment = BN.newInt_(currentTimestamp)
            if lastPayment != 0 {
              PaymentStreamManager.gqlClient.query(
                ~query=module(Query.GetLatestPayment),
                Query.GetLatestPayment.makeVariables(~streamID=userId, ~lastPayment, ()),
              )
              ->JsPromise.map(result =>
                switch result {
                | Ok({data: {payments}}) =>
                  let _ = Array.map(payments, payment => {
                    let paymentAmount = payment.paymentAmount
                    let paymentState = payment.paymentState
                    let paymentTimestamp = payment.paymentTimestamp
                    if paymentState == "COMPLETE" {
                      Js.log("last payment is COMPLETE")
                      let remainingPayments = BN.sub(numberOfPayments, numberOfPaymentsMade)
                      let intervalInSeconds = BN.mul(interval, CONSTANTS.big60)
                      let extraPayments = BN.div(
                        BN.sub(currentPayment, nextPayment),
                        intervalInSeconds,
                      )
                      let extraPaymentsMade = BN.add(extraPayments, CONSTANTS.big1)
                      let finalPayment = BN.min(extraPaymentsMade, remainingPayments)
                      let finalAmount = BN.mul(amount, finalPayment)
                      let _ = makePayment(
                        ~recipientAddress=recipient,
                        ~amount=finalAmount->BN.toString,
                        ~streamID=userId,
                        ~currentPayment=nextPayment,
                      )
                      if numberOfPayments == BN.add(numberOfPaymentsMade, finalPayment) {
                        PaymentStreamManager.gqlClient.mutate(
                          ~mutation=module(Query.CloseStreamEntry),
                          Query.CloseStreamEntry.makeVariables(
                            ~id=userId,
                            ~paymentsMade=numberOfPayments->BN.toNumber,
                            ~state="CLOSED",
                            (),
                          ),
                        )
                        ->JsPromise.map(result =>
                          switch result {
                          | Ok(_result) => Js.log("success close entry: CLOSED")
                          | Error(error) => Js.log2("error close entry: ", error)
                          }
                        )
                        ->ignore
                      } else {
                        let newPaymentsMade = BN.add(numberOfPaymentsMade, finalPayment)
                        let intervalInSeconds = BN.mul(interval, CONSTANTS.big60)
                        let newNextPayment = BN.add(
                          nextPayment,
                          BN.mul(finalPayment, intervalInSeconds),
                        )
                        PaymentStreamManager.gqlClient.mutate(
                          ~mutation=module(Query.UpdateStreamEntry),
                          Query.UpdateStreamEntry.makeVariables(
                            ~id=userId,
                            ~paymentsMade=newPaymentsMade->BN.toNumber,
                            ~nextPayment=newNextPayment->BN.toNumber,
                            ~lastPayment=nextPayment->BN.toNumber,
                            (),
                          ),
                        )
                        ->JsPromise.map(result =>
                          switch result {
                          | Ok(_result) =>
                            Js.log3("success payment made: ", newPaymentsMade, newNextPayment)
                          | Error(error) => Js.log2("error payment made: ", error)
                          }
                        )
                        ->ignore
                      }
                    }
                    if paymentState == "PENDING" {
                      Js.log("last payment is PENDING")
                    }
                    if paymentState == "ERROR" {
                      Js.log("last payment is ERROR")
                    }
                  })
                | Error(error) => Js.log2("error last payment: ", error)
                }
              )
              ->ignore
            }
          })
        | Error(error) => Js.log2("error retrieving stream data", error)
        }
      )
      ->ignore
    },
    (),
  )

  start(job)
} /* execute micropayment amount to recipientAddress [POST request with parameters */
