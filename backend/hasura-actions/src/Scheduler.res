open BsCron

@decco.encode
type makePaymentRequest = {
  amount: string,
  identifier: option<string>,
}

// let dummyData = [
//   {
//     recipient: "0xc788F08a2aAf539111e2a2D85BD4B324FBE37B15",
//     addressTokenStream: "0xb38981469B7235c42DDa836295bE8825Eb4A6389",
//     lengthOfPayment: 86400, // seconds [86400 equals one day.] Must be a multiple of 60
//     interval: 60, // this will always be 60 for our demo
//     // TODO: these values should be BigInt and use `@decco.codec` as the conversion function
//     rate: "1",
//     deposit: "7200",
//     numerOfPaymentsMade: 0,
//     totalNumberOfPaymentsToMake: 1440,
//   },
//   // {
//   //   recipient: "0xc788F08a2aAf539111e2a2D85BD4B324FBE37B15",
//   //   addressTokenStream: "0xb38981469B7235c42DDa836295bE8825Eb4A6389",
//   //   lengthOfPayment: 86400, // seconds [86400 equals one day.] Must be a multiple of 60
//   //   interval: 60, // this will always be 60 for our demo
//   //   // TODO: these values should be BigInt and use `@decco.codec` as the conversion function
//   //   rate: "1",
//   //   deposit: "14400",
//   //   numerOfPaymentsMade: 0,
//   //   totalNumberOfPaymentsToMake: 1440,
//   // },
// |];

let makePayment = (~recipientAddress, ~amount) => {
  Js.log("making payment")
  let requestString =
    "http://raiden1:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/" ++
    recipientAddress
  Js.log2(requestString, amount)
  Fetch.fetchWithInit(
    requestString,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(
        {amount: amount, identifier: None}->makePaymentRequest_encode->Js.Json.stringify,
      ),
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
      (),
    ),
  )
  ->JsPromise.then(Fetch.Response.json)
  ->JsPromise.map(json => {
    Js.log2("THE RESULT:", json)
  })
}

// let paymentHandler = (item: recipientDbData) =>
//   if (item.numerOfPaymentsMade == item.totalNumberOfPaymentsToMake) {
//     ();
//   } else {
//     let _ = makePayment(item.recipient, item.rate);
//     // If it was a success, item.numerOfPaymentsMade ++;
//     // Otherwise print out little shit error
//     ();
//   };

/*

0xC563388e2e2fdD422166eD5E76971D11eD37A466

0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92

curl -X POST --data-raw '{"amount": "100000000000000000"}' http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92

--data-raw '{"amount":"10000000000000000000","identifier":"1612189154951"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:79.0) Gecko/20100101 Firefox/79.0' -H 'Accept: application/json, text/plain, *' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/json' -H 'Origin: http://localhost:5001' -H 'Connection: keep-alive' -H 'Referer: http://localhost:5001/ui/home' --data-raw '{"amount":"10000000000000000000","identifier":"1612189154951"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'Content-Type: application/json' --data-raw '{"amount":"100000000000000000","identifier":"86"}'

curl 'http://localhost:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92' -H 'Content-Type: application/json' --data '{"amount":"100000000000000000","identifier":"86"}'
*/

let startProcess = () => {
  /* let _ = makePayment(
    ~recipientAddress="0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92",
    ~amount="100000000000000000",
  )*/
  let job = CronJob.make(
    #CronString("* * * * *"), // every minute
    _ => {
      Js.log("Printing every minute")
      PaymentStreamManager.gqlClient.query(~query=module(Query.GetStreamData), ())
      ->JsPromise.map(result =>
        switch result {
        | Ok({data: {streams}}) =>
          Js.log2("wyn success: ", streams)
          let _ = Array.map(streams, stream => {
            let userId = stream.id
            let recipient = stream.recipient
            let amount = stream.amount
            let paymentTick = stream.paymentTick
            let interval = stream.interval
            let numberOfPayments = stream.numberOfPayments
            let numberOfPaymentsMade = stream.numberOfPaymentsMade
            if paymentTick == interval {
              //let _ = makePayment(~recipientAddress=recipient, ~amount)
              if numberOfPayments == numberOfPaymentsMade + 1 {
                PaymentStreamManager.gqlClient.mutate(
                  ~mutation=module(Query.CloseStreamEntry),
                  Query.CloseStreamEntry.makeVariables(
                    ~id=userId,
                    ~paymentsMade=numberOfPayments,
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
                let newPaymentTick = 1
                let newPaymentsMade = numberOfPaymentsMade + 1
                PaymentStreamManager.gqlClient.mutate(
                  ~mutation=module(Query.UpdateStreamEntry),
                  Query.UpdateStreamEntry.makeVariables(
                    ~id=userId,
                    ~paymentsMade=newPaymentsMade,
                    ~paymentTick=newPaymentTick,
                    (),
                  ),
                )
                ->JsPromise.map(result =>
                  switch result {
                  | Ok(_result) => Js.log2("success payment made: ", newPaymentsMade)
                  | Error(error) => Js.log2("error payment made: ", error)
                  }
                )
                ->ignore
              }
            } else {
              let newPaymentTick = paymentTick + 1
              PaymentStreamManager.gqlClient.mutate(
                ~mutation=module(Query.UpdateStreamEntry),
                Query.UpdateStreamEntry.makeVariables(
                  ~id=userId,
                  ~paymentsMade=numberOfPaymentsMade,
                  ~paymentTick=newPaymentTick,
                  (),
                ),
              )
              ->JsPromise.map(result =>
                switch result {
                | Ok(_result) => Js.log2("success payment tick: ", newPaymentTick)
                | Error(error) => Js.log2("error payment tick: ", error)
                }
              )
              ->ignore
            }
          })
        /* let len = Belt.Array.length(streams) - 1
          for i in 0 to len {
            switch streams[i] {
            | Some(stream) =>
              let userId = stream.id
              let recipient = stream.recipient
              let amount = stream.amount
              let paymentTick = stream.paymentTick
              let interval = stream.interval
              let numberOfPayments = stream.numberOfPayments
              let numberOfPaymentsMade = stream.numberOfPaymentsMade
              if paymentTick == interval {
                //let _ = makePayment(~recipientAddress=recipient, ~amount)
                if numberOfPayments == numberOfPaymentsMade + 1 {
                  let _ = 0
                  //TODO remove row from streams table
                  PaymentStreamManager.gqlClient.mutate(
                    ~mutation=module(Query.CloseStreamEntry),
                    Query.CloseStreamEntry.makeVariables(
                      ~id=userId,
                      ~paymentsMade=numberOfPayments,
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
                  let newPaymentTick = 1
                  let newPaymentsMade = numberOfPaymentsMade + 1
                  PaymentStreamManager.gqlClient.mutate(
                    ~mutation=module(Query.UpdateStreamEntry),
                    Query.UpdateStreamEntry.makeVariables(
                      ~id=userId,
                      ~paymentsMade=newPaymentsMade,
                      ~paymentTick=newPaymentTick,
                      (),
                    ),
                  )
                  ->JsPromise.map(result =>
                    switch result {
                    | Ok(_result) => Js.log2("success payment made: ", newPaymentsMade)
                    | Error(error) => Js.log2("error payment made: ", error)
                    }
                  )
                  ->ignore
                }
              } else {
                let newPaymentTick = paymentTick + 1
                PaymentStreamManager.gqlClient.mutate(
                  ~mutation=module(Query.UpdateStreamEntry),
                  Query.UpdateStreamEntry.makeVariables(
                    ~id=userId,
                    ~paymentsMade=numberOfPaymentsMade,
                    ~paymentTick=newPaymentTick,
                    (),
                  ),
                )
                ->JsPromise.map(result =>
                  switch result {
                  | Ok(_result) => Js.log2("success payment tick: ", newPaymentTick)
                  | Error(error) => Js.log2("error payment tick: ", error)
                  }
                )
                ->ignore
              }
            | None => Js.log2("nothing: ", streams)
            }
          }*/
        | Error(error) => Js.log2("wyn error: ", error)
        }
      )
      ->ignore
      //
    },
    (),
  )

  start(job)
} /* execute micropayment amount to recipientAddress [POST request with parameters */
