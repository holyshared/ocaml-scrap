let create_user = User.make

let () =
  let user = User.make ~name:"foo" ~password:"okgoogle" in
  User.display user
