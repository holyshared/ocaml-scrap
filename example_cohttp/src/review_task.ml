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


let token_with f vars =
  match Env_var.require "GITHUB_TOKEN" vars with
    | Ok token -> Ok (f ~token)
    | Error e -> Error e

let user_with f vars =
  match Env_var.require "GITHUB_USER" vars with
    | Ok user -> Ok (f ~user)
    | Error e -> Error e

let repo_with f vars =
  match Env_var.require "GITHUB_REPO" vars with
    | Ok repo -> Ok (f ~repo)
    | Error e -> Error e

let arg_with prev next vars =
  match prev with
    | Ok f -> next f vars
    | Error e -> Error e

let args_with ~f ~vars =
  let token f = arg_with f token_with vars in
  let user f = arg_with f user_with vars in
  let repo f = arg_with f repo_with vars in
  Ok f |> token |> user |> repo

let create_commit_comment ~vars =
  let content = {
    path="README.md";
    position=1;
    commit_id="db56442e1ab59a21951c5c7d403c30e5d36032cb";
    body="nyan, nyan"
  } in
  let create_commit_comment = args_with ~f:Review.create_commit_comment ~vars in
  match create_commit_comment with
    | Ok f -> f ~num:2 ~content
    | Error e -> Error e

let create_review ~vars =
  let content = {
    body = "nyan, nyan";
    event = "COMMENT";
    comments = None;
  } in
  let review = args_with ~f:Review.create ~vars in
  match review with
    | Ok f -> f ~num:2 ~content
    | Error e -> Error e
