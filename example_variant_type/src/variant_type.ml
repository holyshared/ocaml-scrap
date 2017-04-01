type config_variable =
  | Host of string
  | Port of string

let string_of_variable v =
  let variable_to_string v =
    match v with
      | Host v -> v
      | Port v -> v in
  match v with
    | Some v -> variable_to_string v
    | None -> "empty"

let value name value =
  match name with
    | "HOST" -> Ok (Host value)
    | "PORT" -> Ok (Port value)
    | _ -> Error ("Undefined: " ^ name)

let collect_of_name name =
  try
    Some (Sys.getenv name)
  with e -> None

let rec collect_of_names t names =
  match names with
    | [] -> Ok t
    | name::remain_names ->
      match collect_of_name name with
        | Some v ->
          let unwrap name v =
            match value name v with
              | Ok v -> Hashtbl.add t name (Some v); collect_of_names t remain_names
              | Error e -> Error e
            in
          unwrap name v
        | None -> Hashtbl.add t name None; collect_of_names t remain_names

let print_env_variables t =
  Hashtbl.iter (
    fun k v -> print_endline (k ^ ":" ^ (string_of_variable v))
  ) t

let () =
  let h = Hashtbl.create 100 in
  let collect h = collect_of_names h ["HOST"; "PORT"] in
  match collect h with
    | Ok v -> print_env_variables v
    | Error e -> print_endline e
