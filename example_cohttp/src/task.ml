type task =
  | CreateReview
  | CommitComment
  | Unknown

let task_of_string = function
  | "CREATE_REVIEW" -> CreateReview
  | "CREATE_COMMIT_COMMRNT" -> CommitComment
  | _ -> Unknown
