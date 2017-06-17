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

let run2 cmd =
  let open Unix in
  let (stdout_r, stdout_w) = Unix.pipe () in
  let (stderr_r, stderr_w) = Unix.pipe () in
  let on_ch_exit out err v =
    let stdout_s = Lwt_io.read_lines out in
    let stderr_s = Lwt_io.read_lines err in
    let rec read_stream st =
      Lwt.bind (Lwt_stream.get st) (fun v ->
        match v with
          | Some d -> print_endline d; read_stream st
          | None -> Lwt.bind (Lwt_io.close err) (fun _ -> Lwt.return "")
      ) in
    let read = Lwt.bind (read_stream stderr_s) (fun v -> read_stream stdout_s) in
    Ok (Lwt_main.run read) in

  let cp = Lwt_process.open_process_none cmd ~stdout:(`FD_move stdout_w) ~stderr:(`FD_move stderr_w) in
  let stdout = Lwt_io.of_unix_fd ~mode:Lwt_io.input stdout_r in
  let stderr = Lwt_io.of_unix_fd ~mode:Lwt_io.input stderr_r in
  match Lwt_main.run (cp#status) with
    | WEXITED v -> on_ch_exit stdout stderr v
    | WSIGNALED v -> on_ch_exit stdout stderr v
    | WSTOPPED v -> on_ch_exit stdout stderr v
