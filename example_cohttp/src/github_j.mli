(* Auto-generated from "github.atd" *)


type review_comment = Github_t.review_comment = {
  commit_id: string;
  path: string;
  position: int;
  body: string
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

