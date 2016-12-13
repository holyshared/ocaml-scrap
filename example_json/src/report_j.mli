(* Auto-generated from "report.atd" *)


type user = Report_t.user = { id: int; name: string }

type report = Report_t.report = { users: user list }

val write_user :
  Bi_outbuf.t -> user -> unit
  (** Output a JSON value of type {!user}. *)

val string_of_user :
  ?len:int -> user -> string
  (** Serialize a value of type {!user}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_user :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> user
  (** Input JSON data of type {!user}. *)

val user_of_string :
  string -> user
  (** Deserialize JSON data of type {!user}. *)

val write_report :
  Bi_outbuf.t -> report -> unit
  (** Output a JSON value of type {!report}. *)

val string_of_report :
  ?len:int -> report -> string
  (** Serialize a value of type {!report}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_report :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> report
  (** Input JSON data of type {!report}. *)

val report_of_string :
  string -> report
  (** Deserialize JSON data of type {!report}. *)

