type urlState =
  | Dashboard
  | Stream
  | Contacts
  | Login
  | Dev

let fromUrl = (url: ReasonReactRouter.url) =>
  switch url.path {
  | list{} => Dashboard->Some
  | list{"stream"} => Stream->Some
  | list{"contacts"} => Contacts->Some
  | list{"login"} => Login->Some
  | list{"dev"} => Dev->Some
  | _ => None // 404
  }

let useRouter = () => ReasonReactRouter.useUrl()->fromUrl
