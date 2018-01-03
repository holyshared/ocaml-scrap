type t = (string * string) list -> unit

let on f = f

let call ~params t =
  t params
