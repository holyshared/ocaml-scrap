module Int = struct
  type t = int
  let compare = compare
end
module IntMap = Map.Make(Int)


module Registry = struct
  type t = (int * string)

  let from pairs =
    let pairs_into pair m =
      let (k, v) = pair in
      IntMap.add k v m in
    List.fold_right pairs_into pairs (IntMap.empty)

  let print t =
    let print_pair k v =
      print_endline ((string_of_int k) ^ " : " ^ v) in
    IntMap.iter print_pair t;
end

let () =
  let examples = [
    (1, "a");
    (2, "b")
  ] in
  let map = Registry.from examples in
  Registry.print map
