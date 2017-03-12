open Formatter

let () =
  let module A = (struct
    let info format = Printf.sprintf format
  end) in
  print_endline (Logger.info (module A) "%s %s" "a" "v")
