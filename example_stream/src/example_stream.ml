type 'a stream_result =
  | Eof of 'a option
  | Consumed of 'a

let char_stream_of_file file =
  try
    Ok (Stream.of_channel (open_in file))
  with Sys_error e -> Error e

module CharStream = struct
  let next t =
    try
      Consumed (Stream.next t)
    with
      Stream.Failure -> Eof None
end

let stop_if_crlf v ~out ~stop ~continue =
  if v = '\n' then
    stop out
  else
    continue v

module LineStream = struct
  let next t =
    let to_consumed buf = Consumed (Buffer.contents buf) in
    let rec next_line t ~buf =
      let add_char_to_buffer v =
        Buffer.add_char buf v;
        next_line t ~buf in
      match CharStream.next t with
        | Eof _ -> Eof (Some (Buffer.contents buf))
        | Consumed v ->
          stop_if_crlf v ~out:buf ~stop:to_consumed ~continue:add_char_to_buffer in
    next_line t ~buf:(Buffer.create 1024)
end

let print_lines t =
  let rec print_out t =
    let end_stream v = match v with
      | Some v -> print_endline v
      | None -> () in
    match LineStream.next t with
      | Eof v -> end_stream v
      | Consumed v -> print_endline v; print_out t in
  print_out t

let () =
  let input_stream file = char_stream_of_file file in
  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s -> print_lines s
