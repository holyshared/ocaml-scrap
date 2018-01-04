type t = (string * string) list -> (unit, string) result

let on f = f

let call ~params t =
  t params
