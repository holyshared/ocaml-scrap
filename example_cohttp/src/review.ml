open Lwt
open Github
open Github_t

let create ~token ~user ~repo ~num ~content =
  let client = init ~token:token ~user ~repo in
  let res = create_review client ~num ~content in
  print_endline (Lwt_main.run res);
  Ok ()

let create_commit_comment ~token ~user ~repo ~num ~content =
  let client = init ~token ~user ~repo in
  let res = create_commit_comment client ~num ~content in
  print_endline (Lwt_main.run res);
  Ok ()
