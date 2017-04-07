module StringMap = Map.Make(String)

let pair_into_map pair m =
  let (k, v) = pair in
  StringMap.add k v m

let string_map_from items =
  List.fold_right pair_into_map items (StringMap.empty)

let print_pair k v =
  print_endline (k ^ " : " ^ v)

let () =
  let examples = [
    ("a", "b");
    ("b", "c")
  ] in
  let result_strings = string_map_from examples in
  StringMap.iter print_pair result_strings;
