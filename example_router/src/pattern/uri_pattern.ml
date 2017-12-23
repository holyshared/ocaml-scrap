module Pattern_group = struct
  type t = string
  let digits = "\\([0-9]+\\)"
  let alphabet = "\\([a-zA-Z]+\\)"
end

module Pattern = struct
  type t = {
    regexp: Str.regexp;
    labels: string list;
  }

  let consume_tokens labels s =
    let rec consume_matched_str labels curr o =
      match labels with
        | [] -> o
        | hd::tail ->
          let v = Str.matched_group curr s in
          (hd, v)::(consume_matched_str tail (curr + 1) o) in
    consume_matched_str labels 1 []

  let is_multi_line s =
    let macthed s =
      match String.index_opt s '\n' with
        | Some _ -> true
        | None -> false in
    macthed s

  let try_resolve t s =
    let macthed s = Str.string_match t.regexp s 0 in
    if macthed s then Some (consume_tokens t.labels s)
    else None

  let resolve t s =
    if is_multi_line s then None
    else try_resolve t s
end

module Pattern_builder = struct
  type group =
    | Const of string
    | Group of string * Pattern_group.t

  type t = group list

  let root = []

  let const s = Const s

  let digits name = Group (name, Pattern_group.digits)

  let alphabet name = Group (name, Pattern_group.alphabet)

  (*
    Pattern_new_builder.(
      root $ (const "users") $ (group ~name:"id" digit) $ (group ~name:"kind" alphabet)
    )
  *)
  let join t p =
    p::t

  let ($) = join

  let pattern_of_groups patterns =
    let pattern_of_result result =
      let open Pattern in
      let (buf, labels) = result in
      let wrap buf =
        let line_buf = Buffer.create 1024 in
        Buffer.add_char line_buf '^';
        Buffer.add_buffer line_buf buf;
        Buffer.add_char line_buf '$';
        buf in
      {
        regexp= (Buffer.contents (wrap buf)) |> Str.regexp;
        labels= (List.rev labels);
      } in

    let append_buf buf v =
      Buffer.add_char buf '/';
      Buffer.add_string buf v; buf in

    let labels_n_times n_labels pattern =
      let (buf, labels) = n_labels in
        match pattern with
          | Const v -> ((append_buf buf v), labels)
          | Group (label, v) -> ((append_buf buf v), label::labels) in

    ListLabels.fold_left ~f:labels_n_times ~init:((Buffer.create 1024), []) patterns
      |> pattern_of_result

  let pattern t =
    pattern_of_groups (List.rev t)

end
