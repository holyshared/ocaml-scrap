(** Formatter module signiture *)
module type Formatter_type = sig
  val info: ('a, unit, string) format -> 'a
end

module DefaultFormatter = struct
  let info format = Printf.sprintf format
end
