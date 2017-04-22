let print_lines t =
  Line_stream.iter t ~f:(fun v -> print_endline v)

let () =
  let input_stream file = Line_stream.of_file file in
  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s -> print_lines s;

  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s -> Line_stream.iter_n s ~n:2 ~f:(fun ss -> List.iter (fun s -> print_endline s) ss)
