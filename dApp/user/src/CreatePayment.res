open Ethers.Utils

let validateInt = interval => {
  let intervalOpt = interval->Belt.Int.fromString

  switch intervalOpt {
  | Some(interval) => interval->Ok
  | None => Error("Must be a valid int >:(")
  }
}

let validateAddress = address => {
  switch address->getAddress {
  | Some(a) => a->ethAdrToStr->Ok
  | None => Error("Must be a valid address")
  }
}

module CreatePaymentStreamForm = %form(
  type input = {
    userAddress: string,
    amount: string,
    interval: string,
    numberOfPayments: string,
    tokenAddress: string,
    startPayment: string,
  }
  type output = {
    userAddress: string,
    amount: string,
    interval: int,
    numberOfPayments: int,
    tokenAddress: string,
    startPayment: int,
  }
  let validators = {
    userAddress: {
      strategy: OnFirstBlur,
      validate: ({userAddress}) => {
        validateAddress(userAddress)
      },
    },
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => {
        if amount->Js.String.length > 0 {
          // do this properly at some stage
          amount->Ok
        } else {
          Error("Amount must have a length greater than zero!")
        }
      },
    },
    interval: {
      strategy: OnFirstBlur,
      validate: ({interval}) => {
        validateInt(interval)
      },
    },
    numberOfPayments: {
      strategy: OnFirstBlur,
      validate: ({numberOfPayments}) => {
        validateInt(numberOfPayments)
      },
    },
    tokenAddress: {
      strategy: OnFirstBlur,
      validate: ({tokenAddress}) => {
        validateAddress(tokenAddress)
      },
    },
    startPayment: {
      strategy: OnFirstBlur,
      validate: ({startPayment}) => {
        validateInt(startPayment)
      },
    },
  }
)

let initialInput: CreatePaymentStreamForm.input = {
  userAddress: "",
  amount: "",
  interval: "",
  numberOfPayments: "",
  tokenAddress: "",
  startPayment: "",
}

@react.component
let make = () => {
  let (createProfileMutate, _createProfileMutateResult) = Queries.CreatePaymentStream.use()
  /// $amount: String!, $interval: Int!, $numberOfPayments: Int!, $recipient: String!, $startPayment: Int!, $state: String, $tokenAddress: String!
  let form = CreatePaymentStreamForm.useForm(~initialInput, ~onSubmit=(
    {userAddress, amount, interval, numberOfPayments, tokenAddress, startPayment},
    _form,
  ) => {
    let _ = createProfileMutate({
      recipient: userAddress,
      amount: amount,
      interval: interval,
      numberOfPayments: numberOfPayments,
      tokenAddress: tokenAddress,
      startPayment: startPayment,
    })
  })
  <Form className="" onSubmit={() => form.submit()}>
    <h2> {"Create Payment"->React.string} </h2>
    <Form.Input
      label={"address"}
      title={"Recipient: "}
      value={form.input.userAddress}
      disabled={form.submitting}
      blur={form.blurUserAddress}
      updateCurried={form.updateUserAddress((input, value) => {
        ...input,
        userAddress: value,
      })}
      result={form.userAddressResult}
    />
    <br />
    <Form.Input
      label={"amount"}
      title={"Amount: "}
      value={form.input.amount}
      disabled={form.submitting}
      blur={form.blurAmount}
      updateCurried={form.updateAmount((input, value) => {
        ...input,
        amount: value,
      })}
      result={form.amountResult}
    />
    <br />
    <Form.Input
      label={"interval"}
      title={"Interval: "}
      value={form.input.interval}
      disabled={form.submitting}
      blur={form.blurInterval}
      updateCurried={form.updateInterval((input, value) => {
        ...input,
        interval: value,
      })}
      result={form.intervalResult}
    />
    <br />
    <Form.Input
      label={"numberPayments"}
      title={"Number of payments"}
      value={form.input.numberOfPayments}
      disabled={form.submitting}
      blur={form.blurNumberOfPayments}
      updateCurried={form.updateNumberOfPayments((input, value) => {
        ...input,
        numberOfPayments: value,
      })}
      result={form.numberOfPaymentsResult}
    />
    <br />
    <Form.Input
      label={"tokenAddress"}
      title={"Token Address"}
      value={form.input.tokenAddress}
      disabled={form.submitting}
      blur={form.blurTokenAddress}
      updateCurried={form.updateTokenAddress((input, value) => {
        ...input,
        tokenAddress: value,
      })}
      result={form.tokenAddressResult}
    />
    <br />
    <Form.Input
      label={"startPayment"}
      title={"Start Payment"}
      value={form.input.startPayment}
      disabled={form.submitting}
      blur={form.blurStartPayment}
      updateCurried={form.updateStartPayment((input, value) => {
        ...input,
        startPayment: value,
      })}
      result={form.startPaymentResult}
    />
    <br />
    <button> {"CREATE STREAM"->React.string} </button>
  </Form>
}
