type process_result = int * string

module type S = sig
  type t
  val exec : Lwt_process.command -> t Lwt.t
  val wait : Lwt_process.command -> f:(string -> unit) -> Unix.process_status Lwt.t
  val exec_buffer : Lwt_process.command -> (process_result, process_result) result Lwt.t
end

module Make(S: S) = struct
  type t = S.t
  let wait cmd ~f = S.wait cmd ~f
  let exec cmd = S.exec cmd
  let exec_buffer = S.exec_buffer
end

module Process_stream = struct
  open Lwt.Infix
  open Lwt_process

  type t = string

  type stream_result =
    | ConsumeNext
    | EndOfStream of string

  let rec read_line cp =
    if Lwt_io.is_busy cp#stdout then
      read_line cp
    else
      Lwt_io.read_line_opt cp#stdout

  let wait cmd ~f =
    let cp = Lwt_process.open_process_in cmd ~stdin:`Close in

    let try_read cp ~f =
      let rec try_read2 cp ~f =
        let on_consumed v =
          match v with
            | Some v -> f v; try_read2 cp ~f
            | None -> Lwt.return_none in
        read_line cp >>= on_consumed in
      try_read2 cp ~f in

    let rec wait2 cp ~f =
      match cp#state with
        | Running ->
          try_read cp ~f >>= (fun v ->
            match v with
              | None -> Lwt_io.close cp#stdout >>= (fun _ -> cp#status)
              | Some _ -> wait2 cp ~f
          )
        | Exited status -> Lwt.return status in
    wait2 cp ~f





  let read_stdout cp ~f =
    let rec try_read cp =
      let on_consumed = function
        | Some v -> f v; try_read cp
        | None -> Lwt.return_none in

      read_line cp >>= on_consumed in
    try_read cp

  let exec_buffer cmd =
    let buf = Buffer.create 1024 in
    let writeln s = Buffer.add_string buf s; Buffer.add_char buf '\n' in
    let cp = Lwt_process.open_process_in cmd ~stdin:`Close in

    let return exit_code =
      if exit_code = 0 then
        Lwt.return_ok (exit_code, Buffer.contents buf)
      else
        Lwt.return_error (exit_code, Buffer.contents buf) in

    let return_result status =
      let open Unix in
      match status with
        | WEXITED v -> return v
        | WSIGNALED v -> return v
        | WSTOPPED v -> return v in

    let rec wait_until_consumed cp =
      let on_consumed = function
        | None ->
          Lwt_io.close cp#stdout
            >>= (fun _ -> cp#status)
            >>= return_result
        | Some _ -> wait_until_consumed cp in
      match cp#state with
        | Running -> read_stdout cp ~f:writeln >>= on_consumed
        | Exited status -> return_result status in

    wait_until_consumed cp



  let exec cmd =
    let buf = Buffer.create 1024 in
    let stream = Lwt_process.pread_lines cmd in

    let rec wait stream =
      let s = Lwt_stream.get stream in

      let buffer_and_next v =
        Buffer.add_string buf v; Lwt.return ConsumeNext in

      let on_consumed = function
        | Some v -> buffer_and_next v
        | None -> Lwt.return (EndOfStream (Buffer.contents buf)) in

      let end_or_next = function
        | EndOfStream v -> Lwt.return v
        | ConsumeNext -> wait stream in

      s >>= on_consumed >>= end_or_next in
    wait stream

end

include Make(Process_stream)
