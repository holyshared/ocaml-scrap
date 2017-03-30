(* Auto-generated from "github.atd" *)


type review_comment = Github_t.review_comment = {
  commit_id: string;
  path: string;
  position: int;
  body: string
}

type draft_review_comment = Github_t.draft_review_comment = {
  path: string;
  position: int;
  body: string
}

type review = Github_t.review = {
  body: string;
  event: string;
  comments: (draft_review_comment list) option
}

val write_review_comment :
  Bi_outbuf.t -> review_comment -> unit
  (** Output a JSON value of type {!review_comment}. *)

val string_of_review_comment :
  ?len:int -> review_comment -> string
  (** Serialize a value of type {!review_comment}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_review_comment :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> review_comment
  (** Input JSON data of type {!review_comment}. *)

val review_comment_of_string :
  string -> review_comment
  (** Deserialize JSON data of type {!review_comment}. *)

val write_draft_review_comment :
  Bi_outbuf.t -> draft_review_comment -> unit
  (** Output a JSON value of type {!draft_review_comment}. *)

val string_of_draft_review_comment :
  ?len:int -> draft_review_comment -> string
  (** Serialize a value of type {!draft_review_comment}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_draft_review_comment :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> draft_review_comment
  (** Input JSON data of type {!draft_review_comment}. *)

val draft_review_comment_of_string :
  string -> draft_review_comment
  (** Deserialize JSON data of type {!draft_review_comment}. *)

val write_review :
  Bi_outbuf.t -> review -> unit
  (** Output a JSON value of type {!review}. *)

val string_of_review :
  ?len:int -> review -> string
  (** Serialize a value of type {!review}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_review :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> review
  (** Input JSON data of type {!review}. *)

val review_of_string :
  string -> review
  (** Deserialize JSON data of type {!review}. *)

