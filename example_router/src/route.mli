type t

type handler = Route_params.t -> (unit, string) result

type routed_handler = t * handler

val post: Pattern.t -> t
val put: Pattern.t -> t
val get: Pattern.t -> t

val resolve: meth:Http.Method.t
  -> uri:string
  -> t
  -> Route_params.t option

val on: t ->
  (Route_params.t -> (unit, string) result) ->
  (t * (Route_params.t -> (unit, string) result))
