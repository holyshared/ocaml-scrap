let env name =
  try
    Some (Sys.getenv name)
  with Not_found -> None

module StringMap = Map.Make(String)
include StringMap

let get key m =
  try
    Some (find key m)
  with
    | Not_found -> None

let from pairs =
  let append pair m =
    let (k, v) = pair in
    add k v m in
  List.fold_right append pairs (empty)

let check_env_variable name =
  match (env name) with
    | Some v -> Ok (name, v)
    | None -> Error (name ^ " empty")

let requires env_variables =
  let append key vars =
    match env key with
      | Some v -> Ok ((key, v)::vars)
      | None -> Error (key ^ " is required") in
  let requires_all env_variables vars =
    let require key o =
      match o with
        | Ok vars -> append key vars
        | Error e -> Error e in
    List.fold_right require env_variables (Ok vars) in

  match requires_all env_variables [] with
    | Ok vars -> Ok (from vars)
    | Error e -> Error e
