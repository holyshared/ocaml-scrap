let create () = Buffer.create 1024

let add_string buf ~s =
  Buffer.add_string buf s; buf

let contents = Buffer.contents
