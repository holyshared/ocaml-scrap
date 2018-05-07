open Example

let () =
  let s = new stack in
  s#push 1;
  s#push 2;
  s#push 3;
  print_endline (string_of_int s#size)
