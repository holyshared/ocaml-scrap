open Arg

module type S = sig
  val usage_desc: string
  val global_options: (key * spec * doc) list
  val subcommands: (module Command.S) list
end

module Registry = MoreLabels.Map.Make(struct
  type t = string
  let compare = compare
end)

module Make(S: S) = struct
  let subcommand = ref None
  let subcommands = S.subcommands

  let registry = ListLabels.fold_left ~f:(
    fun subcommands cmd ->
      let module C = (val cmd: Command.S) in
      Registry.add ~key:C.name ~data:(module C: Command.S) subcommands
  ) ~init:Registry.empty S.subcommands

  let desc ?(indent=2) buf =
    let indent_s = String.make indent ' ' in
    let desc buf = ListLabels.fold_left ~f:(
      fun buf b ->
        let module C = (val b: Command.S) in
        Cli_usage.(
          buf |>
          add_string ~s:indent_s |>
          add_string ~s:C.name |>
          add_string ~s:" " |>
          add_string ~s:C.short_desc |>
          add_string ~s:"\n"
        )
    ) ~init:buf subcommands in
    Cli_usage.(
      buf |>
      add_string ~s:"Commands:\n" |>
      desc
    )

  let usage_desc () =
    Cli_usage.(
      create () |>
      add_string ~s:S.usage_desc |>
      desc ~indent:2 |>
      add_string ~s:"\nGlobal options" |>
      contents
    )

  let help_message = usage_string S.global_options (usage_desc ())

  let set_subcommand cmd =
    subcommand := Some cmd; cmd

  let parse_subcommand s =
    if Registry.mem s registry then
      set_subcommand s
    else
      raise (Bad (s ^ " is an unsupported command"))

  let parse_subcommand_args s =
    let subcommand = parse_subcommand s in
    let command = Registry.find subcommand registry in
    let module C = (val command: Command.S) in
    C.parse_args ()

  let noop () = ()

  let run ?(before=noop) () =
    let parsed_subcommand () =
      match !subcommand with
        | Some cmd -> cmd
        | None -> raise Not_found in
    before ();
    try
      let command = Registry.find (parsed_subcommand ()) registry in
      let module C = (val command: Command.S) in
      C.run ()
    with
      Not_found -> print_endline help_message

  let parse_args () =
    try
      Ok (parse_dynamic (ref S.global_options) parse_subcommand_args (usage_desc ()))
    with
      | Help s -> Error s
      | Bad s -> Error s
end
