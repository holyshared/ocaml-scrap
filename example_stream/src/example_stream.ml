let print_lines t =
  Line_stream.iter t ~f:(fun v -> print_endline v)

let () =
  let input_stream file = Line_stream.of_file file in
  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s -> print_lines s;

  match input_stream "fixtures/input.txt" with
    | Error e -> print_endline e
    | Ok s ->
      let p s = print_endline s in
    List.iter p (Line_stream.take s ~n:2);
