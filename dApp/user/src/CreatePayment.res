open Ethers.Utils


let validateInt = (interval) => {
  let intervalOpt = interval->Belt.Int.fromString

  switch(intervalOpt){
    | Some(interval) => interval->Ok
    | None=>Error("Must be a valid int >:(")
  }
}

let validateAddress = (address) => {
  switch(address->getAddress){
    | Some(a) => a->->ethAdrToStr->Ok
    | None=> Error("Must be a valid address")
  }
}

module ChangeUsernameForm = %form(
  type input = {
    userAddress: string,
    amount: string,
    interval: string,
    numberOfPayments: string,
    tokenAddress: string,
    startPayment: string
  }
  type output = {
    userAddress: string,
    amount: string,
    interval: int,
    numberOfPayments: int,
    tokenAddress: string,
    startPayment: int
  }
  let validators = {
    userAddress: {
      strategy: OnFirstBlur,
      validate: ({userAddress}) => {
        validateAddress(userAddress)
      }
    },
    amount: {
      strategy: OnFirstBlur,
      validate: ({amount}) => {
        if(amount->Js.String.length>0){ // do this properly at some stage
          amount->Ok
        }
        else{
          Error("Amount must have a length greater than zero!")
        }
      }
    },
    interval: {
      strategy: OnFirstBlur,
      validate: ({interval}) => {
        validateInt(interval)
      }
    },
    numberOfPayments: {
      strategy: OnFirstBlur,
      validate: ({numberOfPayments}) => {
        validateInt(numberOfPayments)
      }
    },
    tokenAddress: {
      strategy: OnFirstBlur,
      validate: ({tokenAddress}) => {
        validateAddress(tokenAddress)
      }
    },
    startPayment: {
      strategy: OnFirstBlur,
      validate: ({startPayment}) => {
        validateInt(startPayment)
      }
    }
  }
)


@react.component
let make = () => {
  let (createProfileMutate, createProfileMutateResult) = Queries.CreatePaymentStream.use()
}
