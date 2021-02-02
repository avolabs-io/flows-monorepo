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
  let requestString =
    "http://raiden1:5001/api/v1/payments/0xC563388e2e2fdD422166eD5E76971D11eD37A466/"
    ++ recipientAddress;
  Js.log2(requestString, amount);
  Fetch.fetchWithInit(
    requestString,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=
        Fetch.BodyInit.make(
          {amount, identifier: None}
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
     });
};

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
  PaymentStreamManager.gqlClient.query(
            ~query=module(Query.GetStreamData), ()
            )->JsPromise.map(result =>
              switch result {
                //| Ok({data: {todos}}) => Js.log2("query To-Dos: ", todos)
                | Ok({data: {streams}}) => Js.log2("wyn success: ", streams)
                | Error(error) => Js.log2("wyn error: ", error)
              }
              
            )->ignore

  let job =
    CronJob.make(
      #CronString("* * * * *"), // every minute
      _ => {

          Js.log("Printing every minute");
          // TODO: grab the open streams from hasura
          // let streams = []
          // let _ = makePayment(~recipientAddress="0x91c0c7b5D42e9B65C8071FbDeC7b1EC54D92AD92",~amount="100000000000000000")
          // let _ = Array.map(streams, item => {item->paymentHandler});

          
        },
      (),
    );

  start(job);
} /* execute micropayment amount to recipientAddress [POST request with parameters*/;
