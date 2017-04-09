let failed e =
  print_endline e; exit 1

let execute_task ~name ~vars =
  let open Review_task in
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
  let vars = ["TASK"; "GITHUB_TOKEN"; "GITHUB_USER"; "GITHUB_REPO"] in
  match Env_var.requires vars with
    | Ok vars -> execute_task_if ~name:(Env_var.get "TASK" vars) ~vars ~f:execute_task
    | Error e -> failed e
