type 'a stream_result =
  | Eof
  | Consumed of 'a

module type S = sig
  type t
  val next: char Stream.t -> t stream_result
end

module Make(S: S) = struct
  type t = S.t
  let of_file file =
    try
      Ok (Stream.of_channel (open_in file))
    with Sys_error e -> Error e
  let next s = S.next s
  let iter s ~f =
    let rec iter s ~f =
      match next s with
        | Consumed v -> f v; iter s ~f
        | Eof -> () in
    iter s ~f
  let take s ~n =
    let rec take_n ~n ~out =
      let add_item ~n ~out = match next s with
        | Eof -> out
        | Consumed v -> take_n ~n:(n - 1) ~out:(v::out) in
      if n <= 0 then
        List.rev out
      else
        add_item ~n ~out in
    take_n ~n ~out:[]
end
