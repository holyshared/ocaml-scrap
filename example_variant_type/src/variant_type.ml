type config_variable =
  | Host of string
  | Port of string

module Config_variable = struct
  type t = (config_variable, string) result
  let string_of_value v =
    let variable_to_string v =
      match v with
        | Host v -> v
        | Port v -> v in
    match v with
      | Some v -> variable_to_string v
      | None -> "empty"

  let value_of_string name value =
    match name with
      | "HOST" -> Ok (Host value)
      | "PORT" -> Ok (Port value)
    | _ -> Error ("Undefined: " ^ name)
end

module App_env = Env_config.Make(struct
  let pick = Env.pick
end) (struct
  type v = config_variable
  let value_of_string = Config_variable.value_of_string
  let string_of_value = Config_variable.string_of_value
end)

let () =
  let collect () = App_env.collect ["HOST"; "PORT"] in
  match collect () with
    | Ok v -> App_env.print v
    | Error e -> print_endline e
