open Sexplib

let () =
  let version = Config.Version.create () in
  let library = Config.Library.create "foo" () in
  print_endline (Config.Version.to_string version);
  print_endline (Config.Library.to_string library)
