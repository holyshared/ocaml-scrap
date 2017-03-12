open Formatter

type t = {
  formatter: (module PrintFormatter_type)
}

let format_for_info (f: (module Formatter_type)) format =
  let module Formatter = (val f) in
  Formatter.info format

let info (f: (module PrintFormatter_type)) format =
  let module Formatter = (val f) in
  Formatter.info format

let info_t t format =
  let module Formatter = (val t.formatter) in
  Formatter.info format
