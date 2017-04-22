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

  let iteri s ~f =
    let rec iteri s ~f ~i =
      match next s with
        | Consumed v -> f i v; iteri s ~f ~i:(i + 1)
        | Eof -> () in
    iteri s ~f ~i:1

  let take s ~n =
    let rec take_n ~n ~out =
      let eof ~out =
        match out with
          | [] -> Eof
          | _ -> Consumed (List.rev out) in
      let add_item ~n ~out = match next s with
        | Eof -> eof ~out
        | Consumed v -> take_n ~n:(n - 1) ~out:(v::out) in
      if n <= 0 then
        Consumed (List.rev out)
      else
        add_item ~n ~out in
    take_n ~n ~out:[]

  let iter_n s ~f ~n =
    let rec iter_n s ~f ~n =
      match take s ~n with
        | Eof -> ()
        | Consumed v -> f v; iter_n s ~f ~n in
    iter_n s ~f ~n
end
