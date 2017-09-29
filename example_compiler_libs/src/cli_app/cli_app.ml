open Arg

let no_color = ref false
let no_color_opt = ("--no-color", Unit (fun v -> no_color := true), " No color")

let verbose = ref false
let verbose_color_opt = ("--verbose", Unit (fun v -> verbose := true), " verbose")

let args_spec = [no_color_opt]

let global_opts () =
  let open Global_options in
  let set_no_color opts = { opts with no_color = !no_color } in
  let set_verbose opts = { opts with verbose = !verbose } in
  default_options () |> set_no_color |> set_verbose

let commands () =
  let cmds = [(module A_command: Command.S); (module B_command: Command.S)] in
  let description_of_command desc cmd =
    let module C = (val cmd: Command.S) in
    desc ^ C.name ^ C.description ^ "\n" in
  ListLabels.fold_left ~f:description_of_command ~init:"" cmds

let run_command s =
  let open Global_options in
  match s with
    | "a" -> A_command.run ~gopts:(global_opts ()) ()
    | "b" -> B_command.run ~gopts:(global_opts ()) ()
    | _ -> A_command.run ~gopts:(global_opts ()) ()

let run () =
  try
    parse_dynamic (ref args_spec) run_command "test [COMMAND] [OPTIONS]"
  with
    | Help s -> prerr_endline s
    | Bad s -> prerr_endline s
