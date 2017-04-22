let print_lines t =
  Line_stream.iter t ~f:(fun v -> print_endline v)

let line_stream_of file = Line_stream.of_file file

let print_all_lines o =
  match o with
    | Error e -> print_endline e
    | Ok s -> print_lines s

let print_iter_n o ~n =
  match o with
    | Error e -> print_endline e
    | Ok s -> Line_stream.iter_n s ~n:2 ~f:(fun ss -> List.iter (fun s -> print_endline s) ss)

let () =
  line_stream_of "fixtures/input.txt" |> print_all_lines;
  line_stream_of "fixtures/input.txt" |> print_iter_n ~n:2
