open Pattern

let p4 () =
  let module Pattern = Uri_pattern.Pattern in
  let module Pattern_builder = Uri_pattern.Pattern_builder in
  let uri_pattern = Pattern_builder.(pattern (root $ (const "users") $ (digits "id") $ (alphabet "kind"))) in
  let match_uri uri =
    match Pattern.resolve uri_pattern uri with
      | Some v -> print_endline ("matched: " ^ (ListLabels.fold_left ~f:(fun o label ->
        let n, v = label in
          o ^ "\n" ^(n ^ ": " ^ v)
        ) ~init:"" v))
      | None -> print_endline "unmatched" in
  print_endline "p4------------------------------";
  ListLabels.iter ~f:match_uri [
    "/users/123/xyz";
    "/users/123/123";
    "/users/123";
    "/users";
    "/users/123/xyz\n/users/123/xyz";
  ]


let () =
  p4 ()
