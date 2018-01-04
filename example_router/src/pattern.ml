type t = {
  regexp: Str.regexp;
  labels: string list;
}

let consume_tokens labels uri =
  let rec consume_matched_str labels curr o =
    match labels with
      | [] -> o
      | hd::tail ->
        let v = Str.matched_group curr uri in
        (hd, v)::(consume_matched_str tail (curr + 1) o) in
  consume_matched_str labels 1 []

let is_multi_line uri =
  let macthed uri =
    match String.index_opt uri '\n' with
      | Some _ -> true
      | None -> false in
  macthed uri

let try_resolve t ~uri =
  let macthed uri = Str.string_match t.regexp uri 0 in
  if macthed uri then Some (consume_tokens t.labels uri)
  else None

let resolve t ~uri =
  if is_multi_line uri then None
  else try_resolve t ~uri
