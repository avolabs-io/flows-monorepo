module SignUpForm = %form(
  type input = {address: string, name: string, description: string}
  type output = {address: string, name: string, description: string}

  let validators = {
    address: {
      strategy: OnFirstBlur,
      validate: ({address}) => {
        switch address {
        | "" => Error("Address is required")
        | address =>
          Ethers.Utils.getAddress(address)->Option.mapWithDefault(
            Error("Couldn't parse address"),
            address => address->Ethers.Utils.ethAdrToStr->Ok,
          )
        }
      },
    },
    name: {
      strategy: OnFirstBlur,
      validate: ({name}) =>
        if name == "" {
          Error("Name is required")
        } else {
          name->Ok
        },
    },
    description: {
      strategy: OnFirstBlur,
      validate: ({description}) => description->Ok,
    },
  }
)

let initialInput: SignUpForm.input = {
  address: "",
  name: "",
  description: "",
}

@react.component
let make = () => {
  let (addUser, _addUserResult) = Queries.AddUser.use()
  let form = SignUpForm.useForm(~initialInput, ~onSubmit=({address, name, description}, _) => {
    let _ = addUser({
      address: address,
      name: name,
      description: description,
    })
  })
  <Form className="" onSubmit={() => form.submit()}>
    <h2> {"Sign Up"->React.string} </h2>
    <Form.Input
      label="address"
      title="Raiden Address: "
      value={form.input.address}
      disabled={form.submitting}
      blur={form.blurAddress}
      updateCurried={form.updateAddress((input, value) => {
        ...input,
        address: value,
      })}
      result={form.addressResult}
    />
    <br />
    <Form.Input
      label="name"
      title="User name: "
      value={form.input.name}
      disabled={form.submitting}
      blur={form.blurName}
      updateCurried={form.updateName((input, value) => {
        ...input,
        name: value,
      })}
      result={form.nameResult}
    />
    <br />
    <Form.Input
      label="name"
      title="Description: "
      value={form.input.description}
      disabled={form.submitting}
      blur={form.blurDescription}
      updateCurried={form.updateDescription((input, value) => {
        ...input,
        description: value,
      })}
      result={form.descriptionResult}
    />
    <button> {"Sign Up"->React.string} </button>
  </Form>
}
