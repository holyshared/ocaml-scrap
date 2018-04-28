(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

let ask msg =
  Printf.printf "%s\n" msg;
  read_line ()

let ask_opt msg =
  let wrap_opt v =
    if (String.length v) <= 0 then None
    else Some v in
  ask msg |> wrap_opt

let ask_require msg =
  let rec try_ask msg =
    match ask_opt msg with
      | Some v -> v
      | None -> try_ask msg in
  try_ask msg

let ask_int msg =
  let rec try_ask msg =
    try
      int_of_string (ask_require msg)
    with | Failure s -> try_ask msg in
  try_ask msg

let ask_opt_int msg =
  let rec try_ask msg =
    match ask_opt msg with
      | None -> None
      | Some v ->
        try
          Some (int_of_string v)
        with
          | Failure s -> try_ask msg in
  try_ask msg


let next q f =
  f q
