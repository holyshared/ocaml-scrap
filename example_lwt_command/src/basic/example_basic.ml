let root_dir = Sys.getcwd ()
let program = Filename.concat root_dir "src/sample"

let () =
  match Client.pread (program, [||]) with
    | Ok _ -> print_endline "end"
    | Error e -> print_endline e
