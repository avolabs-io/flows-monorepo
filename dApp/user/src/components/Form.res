@react.component
let make = (~className, ~onSubmit, ~children) => {
  <form
    className
    onSubmit={event => {
      if !(event->ReactEvent.Form.defaultPrevented) {
        event->ReactEvent.Form.preventDefault
      }
      onSubmit()
    }}>
    children
  </form>
}

module Input = {
  @react.component
  let make = (~label, ~title, ~value, ~blur, ~updateCurried, ~result, ~disabled) => {
    <>
      <label htmlFor={label}> {title->React.string} </label>
      <input
        id={label}
        type_="text"
        value={value}
        disabled={disabled}
        onBlur={_ => blur()}
        onChange={event => updateCurried((event->ReactEvent.Form.target)["value"])}
      />
      {switch result {
      | Some(Error(message)) => <div> {message->React.string} </div>
      | _ => React.null
      }}
    </>
  }
}
