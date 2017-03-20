open Formatter

let log format =
  info (fun s -> print_endline s) format

let () =
  log "%s %s" "a" "b";
  log "%s %s %s" "a" "b" "c";
