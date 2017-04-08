open Github
open Github_t

type task =
  | CreateReview
  | CommitComment
  | Unknown

let task_of_string = function
  | "CREATE_REVIEW" -> CreateReview
  | "CREATE_COMMIT_COMMRNT" -> CommitComment
  | _ -> Unknown

let create_commit_comment ~vars =
  let content = {
    path="README.md";
    position=1;
    commit_id="db56442e1ab59a21951c5c7d403c30e5d36032cb";
    body="nyan, nyan"
  } in
  let create = Review.create_commit_comment ~user:"holyshared" ~repo:"ocaml-scrap" in
  match Env_var.require "TOKEN" vars with
    | Ok token -> create ~token ~num:2 ~content
    | Error e -> Error e

let create_review ~vars =
  let content = {
    body = "nyan, nyan";
    event = "COMMENT";
    comments = None;
  } in
  let create = Review.create ~user:"holyshared" ~repo:"ocaml-scrap" in
  match Env_var.require "TOKEN" vars with
    | Ok token -> create ~token ~num:2 ~content
    | Error e -> Error e
