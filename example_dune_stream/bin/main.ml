let buffer_size = 1000

let create_stream filename =
  Stream.of_channel (open_in filename)

let read_line stream =
  let rec aux buf =
    match Stream.peek stream with
    | None ->
        if Buffer.length buf > 0 then Some (Buffer.contents buf) else None
    | Some c ->
        Stream.junk stream;
        if c = '\n' then Some (Buffer.contents buf)
        else (Buffer.add_char buf c; aux buf)
  in
  aux (Buffer.create buffer_size)

let () =
  let stream = create_stream "lines.txt" in
  let rec output_lines () =
    match read_line stream with
    | Some line -> print_endline line; output_lines ()
    | None -> ()
  in
  output_lines ()