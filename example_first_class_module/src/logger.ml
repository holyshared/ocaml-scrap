open Formatter

let info (f: (module Formatter_type)) format =
  let module Formatter = (val f) in
  Formatter.info format
