(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

val ask: string -> string
val ask_map: string -> f:(string -> 'a) -> 'a
val ask_int: string -> int

val ask_opt: string -> string option
val ask_require: string -> string
val ask_opt_int: string -> int option

val next: 'a -> ('a -> 'b) -> 'b
