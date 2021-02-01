type t =
  | Main
  | Login

let fromUrl = (url: ReasonReactRouter.url) =>
  switch url.path {
  | list{} => Main->Some
  | list{"login"} => Login->Some
  | _ => None // 404
  }

let useRouter = () => ReasonReactRouter.useUrl()->fromUrl
