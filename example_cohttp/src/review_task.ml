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


let with_token f vars =
  match Env_var.require "GITHUB_TOKEN" vars with
    | Ok token -> Ok (f ~token)
    | Error e -> Error e

let with_user f vars =
  match Env_var.require "GITHUB_USER" vars with
    | Ok user -> Ok (f ~user)
    | Error e -> Error e

let with_repo f vars =
  match Env_var.require "GITHUB_REPO" vars with
    | Ok repo -> Ok (f ~repo)
    | Error e -> Error e

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
  let create = Review.create in
  let create_with_token = with_token create vars in
  let create_with_user =
    match create_with_token with
      | Ok f -> with_user f vars
      | Error e -> Error e in
  let create_with_repo =
    match create_with_user with
      | Ok f -> with_repo f vars
      | Error e -> Error e in

  match create_with_repo with
    | Ok f -> f ~num:2 ~content
    | Error e -> Error e
