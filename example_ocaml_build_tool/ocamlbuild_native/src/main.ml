let try_loadfile f =
  let open Dynlink in
  try
    loadfile "_build/libexample/libexample.cmxs";
    Ok "_build/libexample/libexample.cmxs"
  with
    | Error e -> Error (error_message e)

let run () =
  print_endline (Example.say ())

let () =
  match try_loadfile "_build/libexample/libexample.cmxs" with
    | Ok loaded_file ->
      print_endline ("File " ^ loaded_file ^ " is loaded");
      run ()
    | Error e -> prerr_endline e; exit 1
