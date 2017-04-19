let char_stream_of_file file =
  try
    Ok (Stream.of_channel (open_in file))
  with Sys_error e -> Error e

let append_if_crlf c ~out =
  if c = '\n' then
    c::out
  else
    out

module LineStream = struct
  let next_line t =
    let rec line t ~out =
      try
        line t ~out:(append_if_crlf (Stream.next t) ~out)
      with Stream.Failure -> out in
    line t ~out:[]

  let next t =
    next_line t
end

let print_lines t =
  let rec print_out t =
    List.iter (fun c -> print_char c) (LineStream.next t);
    print_out t in
  print_out t

let () =
  let input_stream file = char_stream_of_file file in
  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s -> print_lines s
