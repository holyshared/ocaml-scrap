open Arg

let name = "sub_command1"
let short_desc = "subcommand example"
let usage_desc = "subcommand example"

let name_v = ref None
let name_opt = ("--name", String (fun s -> name_v := Some s), "name")

let args_spec = [name_opt]

let parse_args () =
  parse_dynamic (ref args_spec) (fun _ -> ()) usage_desc

let run () =
  Task.task ?name:(!name_v) ()
