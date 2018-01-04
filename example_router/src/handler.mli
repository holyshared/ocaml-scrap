type t

val on: ((string * string) list -> (unit, string) result) -> t

val call: params:(string * string) list
  -> t
  -> (unit, string) result
