module type S = sig
  type t
  val exec : Lwt_process.command -> t Lwt.t
  val wait : Lwt_process.command -> f:(string -> unit) -> Unix.process_status Lwt.t
end

module Make(S: S) = struct
  type t = S.t
  let wait cmd ~f = S.wait cmd ~f
  let exec cmd = S.exec cmd
end

module Process_stream = struct
  open Lwt.Infix
  open Lwt_process

  type t = string

  type stream_result =
    | ConsumeNext
    | EndOfStream of string

  let rec read_line cp =
    (* let read_stdout () = Lwt_io.read_line_opt cp#stdout in *)
(*
    let on_raise_error exn =
      match exn with
        | Lwt_io.Channel_closed _ -> Lwt.return_none
        | End_of_file -> Lwt.return_none
        | e -> raise e
      in*)
    if Lwt_io.is_busy cp#stdout then
      read_line cp
    else
      Lwt_io.read_line_opt cp#stdout

  let wait cmd ~f =
    let cp = Lwt_process.open_process_in cmd ~stdin:`Close in
    let try_read cp ~f =
      let rec try_read2 cp ~f =
        let a v = match v with
          | Some v -> f v; try_read2 cp ~f
          | None -> Lwt.return_none in
        read_line cp >>= a in
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
