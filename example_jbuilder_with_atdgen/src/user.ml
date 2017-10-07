let make ~name ~description =
  User_t.({ name=name; description=description })

let name_of t =
  User_t.(t.name)

let description_of t =
  User_t.(t.description)

let string_of_user t = Buffer.(
  let buf = create 1024 in
    add_string buf "User:\n";
    add_string buf (Printf.sprintf "  name: %s\n" (name_of t));
    add_string buf (Printf.sprintf "  description: %s\n" (description_of t));
    contents buf
  )

let puts ?(out=stdout) t =
  output_string out (string_of_user t)

let display t = puts t
