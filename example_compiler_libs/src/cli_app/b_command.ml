open Arg

let name = "b"

let description =
  "Usage: test b [OPTIONS]\n\nOptions:"

let args_spec = []

let parse_args () =
  try
    parse_dynamic (ref args_spec) (fun _ -> ()) description
  with
    | Help s -> prerr_endline s
    | Bad s -> prerr_endline s

let run ~gopts () =
  let open Global_options in
  parse_args ();
  print_endline (string_of_bool gopts.no_color)
