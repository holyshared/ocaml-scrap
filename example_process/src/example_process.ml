open Process
open Process.Output

let () =
  let result = run "tests/bin/stderr_output" [||] in
  List.iter print_endline result.stderr
