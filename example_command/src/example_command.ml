open Cmdliner

let count =
  let doc = "Repeat the message $(docv) times." in
  Arg.(value & opt int 10 & info ["c"; "count"] ~docv:"COUNT" ~doc)

let msg =
  let doc = "Overrides the default message to print." in
  let env = Arg.env_var "CHORUS_MSG" ~doc in
  let doc = "The message to print." in
  Arg.(value & pos 0 string "Revolt!" & info [] ~env ~docv:"MSG" ~doc)

let chorus count msg =
  for i = 1 to count do print_endline msg done

let chorus_t = Term.(const chorus $ count $ msg)

let info =
  let doc = "document message" in
  let man = [ `S "BUGS"; `P "Email bug reports to <hehey at example.org>."; ] in
  Term.info "program_example" ~version:"1.0.0" ~doc ~man

let program_terminate = function
  | `Error _ -> exit 1
  | _ -> exit 0

let () =
  program_terminate (Term.eval (chorus_t, info))
