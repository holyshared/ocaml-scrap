open Arg

let verbose = ref Log_level.Info
let verbose_opt = ("--verbose", Unit (fun v -> verbose := Log_level.Debug;), " Verbose")

let no_color = ref false
let no_color_opt = ("--no-color", Unit (fun v -> no_color := true), " No color")

let global_options = align ~limit:15 [no_color_opt; verbose_opt]

include Cli.Make(struct
  let usage_desc = "Compiler libs example\n\n"
  let global_options = global_options
  let subcommand = ref "help"
  let subcommands = [
    (module Sub_command1: Command.S);
    (module Sub_command1: Command.S)
  ]
end)

let on_failed msg =
  prerr_endline msg; exit (-1)

let configure () =
  Log.configure ~level:!verbose ~coloring:(not (!no_color))

let run_command () =
  run ~before:configure ()

let run () =
  match parse_args () with
    | Ok _ -> run_command ()
    | Error msg -> on_failed msg
