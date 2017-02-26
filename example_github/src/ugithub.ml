open Cmdliner
open Pull_request

let user =
  let doc = "user name of github" in
  Arg.(value & opt string "holyshared" & info ["user"] ~doc)

let repo =
  let doc = "repository of github" in
  Arg.(value & opt string "ocaml-scrap" & info ["repo"] ~doc)

let print_of_pull_requests user repo =
  print_of_pull_requests ~user:user ~repo:repo

let pull_requests_t = Term.(const print_of_pull_requests $ user $ repo)

let info =
  let doc = "Utility program for Github" in
  let man = [ `S "BUGS"; `P "Email bug reports to <holy.shared.design@gmail.com>."; ] in
  Term.info "ugithub" ~version:"0.1.0" ~doc ~man

let program_terminate = function
  | `Error _ -> exit 1
  | _ -> exit 0

let () =
  program_terminate (Term.eval (pull_requests_t, info))
