module Params = MoreLabels.Map.Make(struct
  type t = string
  let compare = compare
end)

type t = string Params.t

let from lvalues =
  let rec append_all values m =
    match values with
      | [] -> m
      | hd::tail ->
        let k, v = hd in
        append_all tail (Params.add ~key:k ~data:v m) in
  append_all lvalues Params.empty

let value ~key t =
  Params.find_opt key t

let vint ~key t =
  match Params.find_opt key t with
    | Some v -> Some (int_of_string v)
    | None -> None
