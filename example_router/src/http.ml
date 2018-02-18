module Method = struct
  type t = Get | Post | Patch | Put | Delete | Head
  let get = Get
  let post = Post
  let put = Put
  let patch = Patch
  let delete = Delete
  let head = Head
  let to_string = function
    | Get -> "GET"
    | Post -> "POST"
    | Patch-> "PATCH"
    | Put -> "PUT"
    | Delete -> "DELETE"
    | Head -> "HEAD"
end
