module Lines = Map.Make(
  struct
  type t = int
  let compare = compare
  end
)

let rec append_all inputs outputs l =
  let line_number = l + 1 in
  match inputs with
    | [] -> outputs
    | hd :: tl -> append_all tl (Lines.add line_number hd outputs) line_number

let lines_from_string s =
  let lines = Lines.empty in
  let strings = Str.split_delim (Str.regexp "\n") s in
  append_all strings lines 0

let () =
  let lines = lines_from_string "a\nb\nc" in
  Lines.iter (fun k v -> print_endline ((string_of_int k) ^ ": " ^ v)) lines
