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

let apply prev next vars =
  match prev with
    | Ok f -> next f vars
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
  let apply_token f = apply f with_token vars in
  let apply_user f = apply f with_user vars in
  let apply_repo f = apply f with_repo vars in
  let review = (apply_repo (apply_user (apply_token (Ok Review.create)))) in
  match review with
    | Ok f -> f ~num:2 ~content
    | Error e -> Error e
