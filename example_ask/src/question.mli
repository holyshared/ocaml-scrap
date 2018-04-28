(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

val ask_opt: string -> string option
val ask_require: string -> string
val ask_int: string -> int
val ask_opt_int: string -> int option
val next: 'a -> ('a -> 'b) -> 'b
