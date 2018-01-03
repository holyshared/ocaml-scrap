module Method: sig
  type t
  val get: t
  val post: t
  val put: t
  val patch: t
  val delete: t
  val head: t
  val to_string: t -> string
end

module Path: sig
  type t
  val of_string: string -> t
end

module Handler: sig
  type t
  val on: (unit -> unit) -> t
  val call: t -> unit
end

module Route: sig
  type t
  val create: path:Path.t -> meth:Method.t -> Handler.t -> t
  val path: t -> Path.t
  val on: t -> Handler.t
end

val create: unit -> Route.t list
val add: path:Path.t ->
  meth:Method.t ->
  on:Handler.t ->
  Route.t list ->
  Route.t list

val resolve: path:Path.t ->
  meth:Method.t ->
  Route.t list ->
  Handler.t option
