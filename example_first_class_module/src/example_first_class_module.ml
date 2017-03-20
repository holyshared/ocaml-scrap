open Formatter
open Logger

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

let file_logger () =
  let module Log = (val File_logger.create stdout) in
  Log.info "%s %s %s\n" "1" "2" "3"

let () =
  let module A = (val create_formatter ()) in
  let module B = (val create_print_formatter ()) in
  let ctx = {
    formatter=(module B)
  } in
  print_endline (Logger.format_for_info (module A) "%s %s" "a" "v");
  Logger.info (module B) "%s %s" "first" "second";
  Logger.info (module B) "%s %s %s" "first" "second" "third";
  Logger.info_t ctx "%s %s %s" "first" "second" "third";
  file_logger ();
