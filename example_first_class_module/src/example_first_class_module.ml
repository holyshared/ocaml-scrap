open Formatter

let () =
  let module Formatter2 = (struct
    let info format = Printf.sprintf format
  end) in
  print_endline (Formatter2.info "%s" "ddd");
  print_endline (Formatter2.info "%s %s" "ddd" "ddd");
