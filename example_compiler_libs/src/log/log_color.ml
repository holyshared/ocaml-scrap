open Misc.Color

type t = color

let start_with ~start ~fmt =
  start ^^ fmt ^^ "\027[0m"

let color_format ~color ~fmt =
  let color_with ~color =
    match color with
      | Black -> start_with ~start:"\027[30m"
      | Red -> start_with ~start:"\027[31m"
      | Green -> start_with ~start:"\027[32m"
      | Yellow -> start_with ~start:"\027[33m"
      | Blue -> start_with ~start:"\027[34m"
      | Magenta -> start_with ~start:"\027[35m"
      | Cyan -> start_with ~start:"\027[36m"
      | White -> start_with ~start:"\027[37m"
       in
  color_with ~color ~fmt
