type t

val on: ((string * string) list -> unit) -> t

val call: params:(string * string) list
  -> t
  -> unit
