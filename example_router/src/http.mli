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
