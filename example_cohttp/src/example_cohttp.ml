open Lwt
open Github

let () =
  let res = create_commit_comment ~token:"a" ~user:"d" ~repo:"a" ~sha:"a" ~content:"d" in
  print_endline (Lwt_main.run res)
