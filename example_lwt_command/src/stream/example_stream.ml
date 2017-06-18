open Process
open Lwt.Infix

let restart_command = ("hh_client", [|"restart"|])
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
  let open Unix in
  (* match Lwt_main.run (Process.wait (Lwt_process.shell "hh_client restart 2>&1") ~f:(fun l -> print_endline l)) with *)
  match Lwt_main.run (Process.wait (Lwt_process.shell "hhvm --version") ~f:(fun l -> print_endline l)) with
    | WEXITED v -> print_endline (string_of_int v); ()
    | WSIGNALED v -> print_endline (string_of_int v); ()
    | WSTOPPED v -> print_endline (string_of_int v); ()

(*
  restart_and_check ()
  |> terminated
*)