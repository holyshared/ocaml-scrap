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
  for i = 1 to count do print_endline msg done;
  `Ok ()

let chorus_t = Term.(ret Term.(const chorus $ count $ msg))

let info =
  let doc = "document message" in
  let man = [ `S "BUGS"; `P "Email bug reports to <hehey at example.org>."; ] in
  Term.info "program_example" ~version:"1.0.0" ~exits:Term.default_exits ~doc ~man

let () =
  Term.exit @@ (Term.eval (chorus_t, info))
