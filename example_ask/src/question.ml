(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

let ask msg =
  Printf.printf "%s\n" msg;
  read_line ()

let ask_map msg ~f =
  f (ask msg)

let ask_int msg =
  let rec try_ask_int msg =
    try
      int_of_string (ask msg)
    with
      | Failure s -> try_ask_int msg in
  try_ask_int msg

let next q f =
  f q
