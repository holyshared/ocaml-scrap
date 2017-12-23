module Pattern = struct
  let digit = "\\([0-9]+\\)"
  let alphabet = "\\([a-zA-Z]+\\)"
end

let const s = s
let digit () = Pattern.digit
(* join (const "/users/") (digit ()) *)
let join s s2 = s ^ s2
let to_regexp s = Str.regexp s
let m ~p s =
  let regexp = to_regexp p in
  let macthed s = Str.string_match regexp s 0 in
  let rec consume_matched_str n o =
    try
      let v = Str.matched_group n s in
      print_endline (string_of_int n);
      v::(consume_matched_str (n + 1) o)
    with Not_found -> o
    | Invalid_argument _ -> o in

  print_endline ("path: " ^ p);

  if macthed s then
    begin
      print_endline ("path macthed");
      consume_matched_str 1 []
    end
  else
    begin
      print_endline ("path unmacthed");
      []
    end
