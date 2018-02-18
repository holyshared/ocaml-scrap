type t = Route.routed_handler list

module type S = sig
  val routes: t
end
