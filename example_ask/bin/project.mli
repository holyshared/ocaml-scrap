(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

open Prompt

module Generator: sig
  val run: string -> int -> unit
end

module Command: sig
  val perform: (string -> int -> unit) -> unit
end
