@react.component
let make = (~renderString) => {

  let (count, setCount) = React.useState(_ => 0)

  React.useEffect1(_ => {
    setCount(_ => count+1)
    None
  }, [renderString])

  <>
  <div>{renderString->React.string}</div>
  <button onClick={_ => setCount(_ => count + 1)}>
    {count -> Js.String2.make->React.string}
  </button>
  </>
}


