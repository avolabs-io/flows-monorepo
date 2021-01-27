// @react.component
// let make = () => {
//   <<h1> {"Login"->React.string} </h1>
// }

type connectorObj = {
  name: string,
  connector: Web3Connectors.injectedType,
  img: string,
  connectionPhrase: string,
}

@module("./bindings/web3-react/connectors")
external connectors: Js.Array.t<connectorObj> = "default"

@react.component
let make = () => {
  let (_connectionStatus, activateConnector) = RootProvider.useActivateConnector()

  <div>
    <p>
      {"Use one of the wallet providers below. "->React.string}
      <small>
        {"(Not sure where to go from here? "->React.string}
        <a href="https://google.com" target="_blank" rel="noopener noreferrer">
          <span>
            {"TODO: put a guide in the blog or something that users can read on if they are confused"->React.string}
          </span>
        </a>
        {")"->React.string}
      </small>
    </p>
    <div
      className={
        open CssJs
        style(.[
          display(#grid),
          gridTemplateColumns([#repeat(#autoFit, #minmax(px(176), fr(0.6)))]),
          maxWidth(px(800)),
        ])
      }>
      {connectors
      ->Array.mapWithIndex((index, connector) =>
        <div
          key={index->string_of_int}
          onClick={e => {
            ReactEvent.Mouse.stopPropagation(e)
            activateConnector(connector.connector)
          }}
          className={
            open CssJs
            style(.[zIndex(1), border(px(1), #solid, rgba(195, 195, 195, #num(0.14)))])
          }>
          <div
            className={
              open CssJs
              style(.[
                margin(px(8)),
                display(#flex),
                justifyContent(#center),
                alignItems(#center),
                flexDirection(column),
                cursor(#pointer),
                borderRadius(px(12)),
                backgroundColor(white),
                hover([backgroundColor(rgb(195, 195, 195))]),
                transition(~duration=200, ~delay=0, ~timingFunction=easeInOut, "background-color"),
              ])
            }>
            <div
              className={
                open Css
                style(list{width(px(45)), height(px(45))})
              }>
              <img
                src=connector.img
                alt=connector.name
                className={
                  open Css
                  style(list{width(#percent(100.)), height(#percent(100.))})
                }
              />
            </div>
            <div
              className={
                open Css
                style(list{fontSize(px(24)), fontWeight(#num(700)), marginTop(em(0.5))})
              }>
              {connector.name->React.string}
            </div>
            <div
              className={
                open Css
                style(list{fontSize(px(15)), marginTop(em(0.35)), color(rgb(169, 169, 188))})
              }>
              {connector.connectionPhrase->React.string}
            </div>
          </div>
        </div>
      )
      ->React.array}
    </div>
  </div>
}
