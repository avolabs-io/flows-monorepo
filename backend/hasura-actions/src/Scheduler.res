Dotenv.config()
@val external hubAddress: option<string> = "process.env.HUB_ADDRESS"

open BsCron

@decco.encode
type makePaymentRequest = {
  amount: string,
  identifier: option<string>,
}

type streamData = {
  streamID: int,
  amount: BN.t,
  interval: BN.t,
  numberOfPayments: BN.t,
  numberOfPaymentsMade: BN.t,
  currentPayment: BN.t,
  nextPayment: BN.t,
}

let makePayment = (~recipientAddress, ~paymentData: streamData) => {
  Js.log("making payment")
  let remainingPayments = BN.sub(paymentData.numberOfPayments, paymentData.numberOfPaymentsMade)
  let intervalInSeconds = BN.mul(paymentData.interval, CONSTANTS.big60)
  let extraPayments = BN.div(
    BN.sub(paymentData.currentPayment, paymentData.nextPayment),
    intervalInSeconds,
  )
  let extraPaymentsMade = BN.add(extraPayments, CONSTANTS.big1)
  let finalPayment = BN.min(extraPaymentsMade, remainingPayments)
  let finalAmount = BN.mul(paymentData.amount, finalPayment)
  PaymentStreamManager.addPaymentEntry(
    ~streamID=paymentData.streamID,
    ~timestamp=paymentData.nextPayment->BN.toNumber,
    ~amount=finalAmount->BN.toString,
  )
  let totalPayments = BN.add(paymentData.numberOfPaymentsMade, finalPayment)
  if BN.eq(paymentData.numberOfPayments, totalPayments) {
    PaymentStreamManager.closeStreamEntry(
      ~streamID=paymentData.streamID,
      ~totalPaymentsMade=paymentData.numberOfPayments->BN.toNumber,
    )
  } else {
    let newPaymentsMade = BN.add(paymentData.numberOfPaymentsMade, finalPayment)
    let intervalInSeconds = BN.mul(paymentData.interval, CONSTANTS.big60)
    let newNextPayment = BN.add(paymentData.nextPayment, BN.mul(finalPayment, intervalInSeconds))
    PaymentStreamManager.updateStreamEntry(
      ~streamID=paymentData.streamID,
      ~totalPaymentsMade=newPaymentsMade->BN.toNumber,
      ~nextPayment=newNextPayment->BN.toNumber,
      ~lastPayment=paymentData.nextPayment->BN.toNumber,
    )
  }
  let address = hubAddress->Option.getWithDefault("http://raiden1:5001")
  let requestString =
    address ++ "/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/" ++ recipientAddress
  Js.log2(requestString, finalAmount->BN.toString)
  Fetch.fetchWithInit(
    requestString,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(
        {amount: finalAmount->BN.toString, identifier: None}
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
    if Js.String.includes("errors", Js.Json.stringify(json)) == false {
      Js.log("SUCCESS")
      //TODO not sure how to get the payment ID back from the AddNewPayment mutation
      /* let paymentID = 1
       PaymentStreamManager.updatePaymentEntry(~paymentID, ~state="COMPLETE") */
    } else {
      Js.log("ERROR")
      //TODO not sure how to get the payment ID back from the AddNewPayment mutation
      /* let paymentID = 1
       PaymentStreamManager.updatePaymentEntry(~paymentID, ~state="ERROR") */
    }
  })
}

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
            let paymentData = {
              streamID: userId,
              amount: amount,
              interval: interval,
              numberOfPayments: numberOfPayments,
              numberOfPaymentsMade: numberOfPaymentsMade,
              currentPayment: currentPayment,
              nextPayment: nextPayment,
            }
            if lastPayment == 0 {
              let _ = makePayment(~recipientAddress=recipient, ~paymentData)
            } else {
              PaymentStreamManager.gqlClient.query(
                ~query=module(Query.GetLatestPayment),
                Query.GetLatestPayment.makeVariables(~streamID=userId, ~lastPayment, ()),
              )
              ->JsPromise.map(result =>
                switch result {
                | Ok({data: {payments}}) =>
                  let _ = Array.map(payments, payment => {
                    let paymentState = payment.paymentState
                    //let paymentAmount = payment.paymentAmount
                    //let paymentTimestamp = payment.paymentTimestamp
                    switch paymentState {
                    | #COMPLETE =>
                      Js.log("last payment is COMPLETE")
                      let _ = makePayment(~recipientAddress=recipient, ~paymentData)
                    | #PENDING => Js.log("last payment is PENDING")
                    | #ERROR => Js.log("last payment is ERROR")
                    | _ => Js.log("future value added")
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

/*
curl -X POST --data-raw '{"amount": "100000000000000000"}' http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92

--data-raw '{"amount":"10000000000000000000","identifier":"1612189154951"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: application/json, text/plain, *' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/json' -H 'Origin: http://localhost:5001' -H 'Connection: keep-alive' -H 'Referer: http://localhost:5001/ui/home' --data-raw '{"amount":"10000000000000000000","identifier":"1612189154951"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'Content-Type: application/json' --data-raw '{"amount":"100000000000000000","identifier":"86"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x6533180A035401d917535d889EfB8CE47Cf3bb22' -H 'Content-Type: application/json' --data '{"amount":"100000000000000000","identifier":"86"}'
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
