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

let execute_task name =
  match task_of_string name with
    | CreateReview -> create_commit_comment_by ""
    | CommitComment -> create_review_by ""
    | Unknown -> Error "Unknown task name"

let execute_task_if name_f f =
  let execute task_name = match f task_name with
    | Ok _ -> print_endline "done"; ()
    | Error e -> failed e in
  match name_f with
    | Some task_name -> execute task_name
    | None -> failed "task is empty"

let check_env_variable name =
  match (env name) with
    | Some _ -> Ok ()
    | None -> Error (name ^ " empty")

let check_task env_variables =
  let rec check_all env_variables =
    match env_variables with
      | [] -> Ok ()
      | hd::remains ->
        match (check_env_variable hd) with
          | Ok _ -> check_all remains
          | Error e -> Error e in
  let check_all_variables variables =
    match check_all variables with
      | Ok _ -> Ok ()
      | Error e -> failed e in
  check_all_variables env_variables

let () =
  match check_task ["TASK"; "GITHUB_TOKEN"] with
    | Ok _ -> execute_task_if (env "TASK") execute_task
    | Error e -> failed e
