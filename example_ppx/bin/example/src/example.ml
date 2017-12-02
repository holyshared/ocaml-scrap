type t = {
  name: string;
  desc: string;
} [@@prefix "user"]

let () =
  let u = {
    name = "a";
    desc = "b"
  } in
  print_endline u.name
