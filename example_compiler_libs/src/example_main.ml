open Arg

let verbose = ref Log_level.Info
let verbose_opt = ("--verbose", Unit (fun v -> verbose := Log_level.Debug;), "verbose")

let no_color = ref false
let no_color_opt = ("--no-color", Unit (fun v -> no_color := true), "no color")

let args_spec = [no_color_opt; verbose_opt]
let usage_description = "compiler libs example"

module SubCommand1 = struct
  let name = ref None
  let name_opt = ("--name", String (fun s -> name := Some s), "name")

  let args_spec = [name_opt]
  let usage_description = "subcommand example"
  let parse_arguments () =
    parse_dynamic (ref args_spec) (fun s -> print_endline s) usage_description

  let run () =
    Task.task ?name:(!name) ()
end

module SubCommands = struct
  type command =
    | Sub1
    | Sub2

  let subcommand = ref Sub1

  let subcommand1 () =
    subcommand := Sub1;
    SubCommand1.parse_arguments ()

  let parse_subcommand_arguments s =
    match s with
      | "sub1" -> subcommand1 ()
      | "sub2" -> subcommand1 ()
      | _ -> ()
end

let parse_arguments () =
  try
    Ok (parse_dynamic (ref args_spec) (
      fun s -> SubCommands.parse_subcommand_arguments s
    ) usage_description)
  with
    | Help s -> Error s
    | Bad s -> Error s

let () =
  match parse_arguments () with
    | Ok _ ->
      begin
        Log.configure ~level:!verbose ~coloring:(not (!no_color));
        match !SubCommands.subcommand with
          | SubCommands.Sub1 -> SubCommand1.run ()
          | SubCommands.Sub2 -> SubCommand1.run ()
      end
    | Error msg -> print_endline msg
