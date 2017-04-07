module StringMap = Map.Make(String)

let rec strings_into_map items lines =
  match items with
    | [] -> lines
    | hd :: tl ->
      let (k, v) = hd in
      strings_into_map tl (StringMap.add k v lines)

let string_map_from items =
  let strings = StringMap.empty in
  strings_into_map items strings

let print_pair k v =
  print_endline (k ^ " : " ^ v)

let () =
  let examples = [
    ("a", "b");
    ("b", "c")
  ] in
  let result_strings = string_map_from examples in
  StringMap.iter print_pair result_strings;
