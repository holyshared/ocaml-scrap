type t = Route.t * Handler.t

let on route handler =
  (route, (Handler.on handler))
