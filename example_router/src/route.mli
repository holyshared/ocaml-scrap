type t

val post: Pattern.t -> t
val put: Pattern.t -> t
val get: Pattern.t -> t

val resolve: meth:Http.Method.t
  -> uri:string
  -> t
  -> (string * string) list option
