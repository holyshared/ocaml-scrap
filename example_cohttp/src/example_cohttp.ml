open Lwt
open Github
open Github_t

let env name =
  try
    Some (Sys.getenv name)
  with Not_found -> None

let create_commit_comment_by token =
  let client = init ~token:token ~user:"holyshared" ~repo:"ocaml-scrap" in
  let content = { path="README.md"; position=1; commit_id="db56442e1ab59a21951c5c7d403c30e5d36032cb"; body="nyan, nyan" } in
  let res = create_commit_comment client ~num:2 ~content:content in
  print_endline (Lwt_main.run res)

let create_review_by token =
  let client = init ~token:token ~user:"holyshared" ~repo:"ocaml-scrap" in
  let content = {
    body = "nyan, nyan";
    event = "COMMENT";
    comments = None;
  } in
  let res = create_review client ~num:2 ~content:content in
  print_endline (Lwt_main.run res)

let () =
  match (env "GITHUB_TOKEN") with
    | Some token -> print_endline token; create_commit_comment_by token
    | None -> exit 1
