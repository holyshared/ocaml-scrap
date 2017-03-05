open Lwt
open Github
open Github_t

let env name =
  try
    Some (Sys.getenv name)
  with Not_found -> None

let create_commit_comment_by token =
  let client = init ~token:token ~user:"holyshared" ~repo:"ocaml-scrap" in
  let content = { path="a"; position=1; commit_id="9fb6ec6a2056276211898736ae797a0c31b53af8"; body="nyan, nyan" } in
  let res = create_commit_comment client ~num:1 ~content:content in
  print_endline (Lwt_main.run res)

let () =
  match (env "GITHUB_TOKEN") with
    | Some token -> print_endline token; create_commit_comment_by token
    | None -> exit 1
