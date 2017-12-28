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
