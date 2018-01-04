type t

val on: (Route_params.t -> (unit, string) result) -> t

val call: params:Route_params.t
  -> t
  -> (unit, string) result
