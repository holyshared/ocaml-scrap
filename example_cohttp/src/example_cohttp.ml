open Lwt
open Github
open Github_t

let failed e =
  print_endline e; exit 1

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

let execute_task ~name ~vars =
  let open Task in
  match task_of_string name with
    | CreateReview -> create_review ~vars
    | CommitComment -> create_commit_comment ~vars
    | Unknown -> Error "Unknown task name"

let execute_task_if ~name ~vars ~f =
  let execute task_name = match f ~name:task_name ~vars with
    | Ok _ -> print_endline "done"; ()
    | Error e -> failed e in
  match name with
    | Some task_name -> execute task_name
    | None -> failed "task is empty"

let () =
  match Env_var.requires ["TASK"; "GITHUB_TOKEN"] with
    | Ok vars -> execute_task_if ~name:(Env_var.get "TASK" vars) ~vars ~f:execute_task
    | Error e -> failed e
