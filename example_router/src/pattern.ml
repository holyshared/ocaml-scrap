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
