let make ~name ~password =
  User_t.({ name=name; password=password })

let name_of t =
  User_t.(t.name)

let password_of t =
  User_t.(t.password)
