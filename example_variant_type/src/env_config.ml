type config_variable =
  | Host of string
  | Port of string

module type S = sig
  type v
  type o = (string, v option) Hashtbl.t
  val collect: string list -> (o, string) result
  val print: o -> unit
end

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

module Make(T: Env.S): S = struct
  type v = config_variable
  type o = (string, v option) Hashtbl.t

  let append_to t name =
    match T.pick name with
      | Some v ->
        let unwrap name v =
          match value name v with
            | Ok v -> Hashtbl.add t name (Some v); Ok t
            | Error e -> Error e in
        unwrap name v
      | None -> Hashtbl.add t name None; Ok t

  let collect_to t names =
    let initial t = Ok t in
    let collect name result =
      match result with
        | Ok t -> append_to t name
        | Error e -> Error e in
    List.fold_right collect names (initial t)

  let collect names =
    let h = Hashtbl.create 100 in
    collect_to h names

  let print t =
    let print_of_variable k v =
      print_endline (k ^ ":" ^ (string_of_variable v)) in
    Hashtbl.iter print_of_variable t
end

include Make(struct
  let pick = Env.pick
end)
