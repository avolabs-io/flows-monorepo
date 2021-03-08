module SignUpForm = %form(
  type input = {address: string, name: string}
  type output = {address: Ethers.ethAddress, name: string}

  let validators = {
    address: {
      strategy: OnFirstBlur,
      validate: ({address}) => {
        switch address {
        | "" => Error("Address is required")
        | address =>
          Ethers.Utils.getAddress(address)->Option.mapWithDefault(
            Error("Couldn't parse address"),
            address => address->Ok,
          )
        }
      },
    },
    name: {
      strategy: OnFirstBlur,
      validate: ({name}) => if(name == ""){
        Error("Name is required")
      }else{
        name->Ok
      }
    }
  }
)

let initialInput: SignUpForm.input = {
  address: "",
  name: ""
}

@react.component
let make = () => {
  let form = SignUpForm.useForm(~initialInput, ~onSubmit=(_, _)=>{
    Js.log("NEEDS TO BE IMPLEMENTED")
  })
  <Form
    className=""
    onSubmit={()=>form.submit()}
  >
    <h2>{"Sign Up"->React.string}</h2>
    <label htmlFor="address"> {"Raiden Address: "->React.string} </label>
    <input
      id="address"
      type_="text"
      value=form.input.address
      disabled=form.submitting
      onBlur={_=>form.blurAddress()}
      onChange={
        event => form.updateAddress((input, value) => {
          ...input,
          address: value,
        }, (event->ReactEvent.Form.target)["value"])
      }
    />
    {
      {switch form.addressResult {
          | Some(Error(message)) => <div> {message->React.string} </div>
          | _ => React.null
      }}
    }
    <br/>
    <label htmlFor="name"> {"Name: "->React.string} </label>
    <input
      id="name"
      type_="text"
      value=form.input.name
      disabled=form.submitting
      onBlur={_=>form.blurName()}
      onChange={
        event => form.updateName((input, value) => {
          ...input,
          name: value,
        }, (event->ReactEvent.Form.target)["value"])
      }
    />
    {
      {switch form.nameResult {
          | Some(Error(message)) => <div> {message->React.string} </div>
          | _ => React.null
      }}
    }
    <br/>
    <button>{"Sign Up"->React.string}</button>
  </Form>
}