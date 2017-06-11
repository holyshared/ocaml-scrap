module type S = sig
  type t
  val exec : Lwt_process.command -> t Lwt.t
end

module Make(S: S) = struct
  type t = S.t
  let exec cmd = S.exec cmd
end

module Process_stream = struct
  open Lwt.Infix
  open Lwt_process

  type t = string

  type stream_result =
    | ConsumeNext
    | EndOfStream of string

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
