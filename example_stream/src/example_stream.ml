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
    let to_consumed out = Consumed out in
    let rec next_line t ~out =
      let add_to_list v = next_line t ~out:(v::out) in
      match CharStream.next t with
        | Eof _ -> Eof (Some (out))
        | Consumed v ->
          stop_if_crlf v ~out ~stop:to_consumed ~continue:add_to_list in
    next_line t []
end

let print_lines t =
  let rec print_out t =
    let print_line v = List.iter (fun c -> print_char c) v in
    let end_stream v = match v with
      | Some v -> print_line v
      | None -> () in
    match LineStream.next t with
      | Eof v -> end_stream v
      | Consumed v -> print_line v; print_out t in
  print_out t

let () =
  let input_stream file = char_stream_of_file file in
  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s -> print_lines s
