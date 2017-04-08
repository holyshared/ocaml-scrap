open Lwt
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

let failed e =
  print_endline e; exit 1

let env name =
  try
    Some (Sys.getenv name)
  with Not_found -> None

module Env_var = struct
  module StringMap = Map.Make(String)
  include StringMap

  let get key m =
    try
      Some (find key m)
    with
      | Not_found -> None

  let from pairs =
    let append pair m =
      let (k, v) = pair in
      add k v m in
    List.fold_right append pairs (empty)

  let check_env_variable name =
    match (env name) with
      | Some v -> Ok (name, v)
      | None -> Error (name ^ " empty")

  let requires env_variables =
    let append key vars =
      match env key with
        | Some v -> Ok ((key, v)::vars)
        | None -> Error (key ^ " is required") in
    let requires_all env_variables vars =
      let require key o =
        match o with
          | Ok vars -> append key vars
          | Error e -> Error e
        in
      List.fold_right require env_variables (Ok vars) in

    match requires_all env_variables [] with
      | Ok vars -> Ok (from vars)
      | Error e -> Error e
end

let create_commit_comment_by token =
  let client = init ~token:token ~user:"holyshared" ~repo:"ocaml-scrap" in
  let content = { path="README.md"; position=1; commit_id="db56442e1ab59a21951c5c7d403c30e5d36032cb"; body="nyan, nyan" } in
  let res = create_commit_comment client ~num:2 ~content:content in
  print_endline (Lwt_main.run res);
  Ok ()

let create_review_by token =
  let client = init ~token:token ~user:"holyshared" ~repo:"ocaml-scrap" in
  let content = {
    body = "nyan, nyan";
    event = "COMMENT";
    comments = None;
  } in
  let res = create_review client ~num:2 ~content:content in
  print_endline (Lwt_main.run res);
  Ok ()

let execute_task ~name ~vars =
  match task_of_string name with
    | CreateReview -> create_review_by ""
    | CommitComment -> create_commit_comment_by ""
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
