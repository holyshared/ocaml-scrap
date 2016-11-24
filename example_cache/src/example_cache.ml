let () =
  let cache = Cache_manager.create 1024 in
  let readed_lines = Source_file.read_all "fixtures/example1.ml" cache in
  let lines = match readed_lines with
    | Source_file.Cache v -> print_endline "from cache"; v
    | Source_file.File v -> print_endline "from file"; v in
  Lines.iter (fun k v -> print_endline ((string_of_int k) ^ ": " ^ v)) lines
