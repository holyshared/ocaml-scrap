type t = Route_handler.t list

module type S = sig
  val routes: t
end
