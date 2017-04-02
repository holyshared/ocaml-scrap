type config_variable =
  | Host of string
  | Port of string

module type S = sig
  type v
  type o = (string, v option) Hashtbl.t
  val collect: string list -> (o, string) result
  val print: o -> unit
end

module Make(T: Env.S) (V: Env_variable.S): S = struct
  type v = V.v
  type o = (string, V.vo) Hashtbl.t
  let append_to t name =
    match T.pick name with
      | Some v ->
        let unwrap name v =
          match V.value_of_string name v with
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
      print_endline (k ^ ":" ^ (V.string_of_variable v)) in
    Hashtbl.iter print_of_variable t
end
