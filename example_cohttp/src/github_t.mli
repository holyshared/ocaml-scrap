(* Auto-generated from "github.atd" *)


type review_comment = {
  commit_id: string;
  path: string;
  position: int;
  body: string
}

type draft_review_comment = { path: string; position: int; body: string }

type review = {
  body: string;
  event: string;
  comments: (draft_review_comment list) option
}
