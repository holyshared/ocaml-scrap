open Process
open Lwt.Infix

let restart_command = ("hh_client", [|"restart"; "--no-load"|])
let check_command = ("hh_client", [|"check"; "--json"|])

let terminated v =
  print_endline v

let verbose v ~f =
  print_endline v;
  f ()

let check () = Process.exec check_command
let restart () = Process.exec restart_command

let restart_and_check () =
  Lwt_main.run (restart () >>= (verbose ~f:check))

let () =
  restart_and_check ()
  |> terminated
