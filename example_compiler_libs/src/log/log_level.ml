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

let to_int = function
  | Emergency -> 600
  | Alert -> 550
  | Critial -> 500
  | Error -> 400
  | Warning -> 300
  | Notice -> 250
  | Info -> 200
  | Debug -> 100

let to_format = function
  | Emergency -> format_of_string "[EMERGENCY] "
  | Alert -> format_of_string "[ALERT] "
  | Critial -> format_of_string "[CRITIAL] "
  | Error -> format_of_string "[ERROR] "
  | Warning -> format_of_string "[WARNING] "
  | Notice -> format_of_string "[NOTICE] "
  | Info -> format_of_string "[INFO] "
  | Debug -> format_of_string "[DEBUG] "

let to_string = function
  | Emergency -> "[EMERGENCY]"
  | Alert -> "[ALERT]"
  | Critial -> "[CRITIAL]"
  | Error -> "[ERROR]"
  | Warning -> "[WARNING]"
  | Notice -> "[NOTICE]"
  | Info -> "[INFO]"
  | Debug -> "[DEBUG]"

let to_color color =
  let open Misc.Color in
  match color with
    | Emergency -> Red
    | Alert -> Red
    | Critial -> Red
    | Error -> Red
    | Warning -> Yellow
    | Notice -> Yellow
    | Info -> Cyan
    | Debug -> White
