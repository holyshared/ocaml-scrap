open Formatter

let create_formatter () =
  let module A = (struct
    let info format = Printf.sprintf format
  end) in
  (module A : Formatter_type)

let create_print_formatter () =
  let module A = (struct
    let info format = Printf.printf format
  end) in
  (module A : PrintFormatter_type)

let () =
  let module A = (val create_formatter ()) in
  let module B = (val create_print_formatter ()) in
  print_endline (Logger.format_for_info (module A) "%s %s" "a" "v");
  Logger.info (module B) "%s %s" "first" "second";
  Logger.info (module B) "%s %s %s" "first" "second" "third";
