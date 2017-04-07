module IntMap = Map.Make(
  struct
    type t = int
    let compare = compare
  end
)

let rec pairs_into_registry pairs results =
  match pairs with
    | [] -> results
    | hd :: tl ->
      let (k, v) = hd in
      pairs_into_registry tl (IntMap.add k v results)

let registry_from pairs =
  let results = IntMap.empty in
  pairs_into_registry pairs results

let print_pair k v =
  print_endline ((string_of_int k) ^ " : " ^ v)

let () =
  let examples = [
    (1, "a");
    (2, "b")
  ] in
  let results = registry_from examples in
  IntMap.iter print_pair results;
