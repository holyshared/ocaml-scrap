type t = (string * string) list option -> unit

let call ~params t =
  t params
