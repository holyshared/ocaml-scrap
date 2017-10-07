let create_user = User.make

let () =
  let user = User.make ~name:"foo" ~description:"okgoogle" in
  User.display user
