open Lwt
open Github

let () =
  let client = init ~token:"a" ~user:"d" ~repo:"a" in
  let res = create_commit_comment client ~sha:"a" ~content:"d" in
  print_endline (Lwt_main.run res)
