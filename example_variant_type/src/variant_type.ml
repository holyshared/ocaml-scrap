let () =
  let collect () = Env_config.collect ["HOST"; "PORT"] in
  match collect () with
    | Ok v -> Env_config.print v
    | Error e -> print_endline e
