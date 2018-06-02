(** https://tools.ietf.org/html/rfc3164 *)
type t =
  | Emergency
  | Alert
  | Critial
  | Error
  | Warning
  | Notice
  | Info
  | Debug

val to_int: t -> int
val to_format: t -> ('a, 'b, 'c, 'd, 'd, 'a) format6
val to_string: t -> string
val to_color: t -> Log_color.t
