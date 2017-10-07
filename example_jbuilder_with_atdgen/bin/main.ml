let create_user = User.make

let () =
  let user = create_user ~name:"foo" ~password:"okgoogle" in
  print_endline (User.name_of user);
  print_endline (User.password_of user)
