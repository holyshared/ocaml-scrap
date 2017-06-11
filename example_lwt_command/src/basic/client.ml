open Lwt_process

type process_result =
  | Exit of int
  | Stop of int
  | Kill of int

let run cmd =
  let cp = open_process_out cmd in
  match Lwt_main.run cp#status with
    | Unix.WEXITED v -> Exit v
    | Unix.WSIGNALED v -> Stop v
    | Unix.WSTOPPED v -> Kill v

let exec cmd =
  let open Unix in
  match Lwt_main.run (Lwt_process.exec cmd) with
    | WEXITED v -> Ok v
    | WSIGNALED v -> Ok v
    | WSTOPPED v -> Ok v

let pread cmd =
  let received_output = Lwt_main.run (Lwt_process.pread cmd) in
  print_endline received_output;
  Ok ()

