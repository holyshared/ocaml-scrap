type t = Route_params.t -> (unit, string) result

let on f = f

let call ~params t =
  t params
