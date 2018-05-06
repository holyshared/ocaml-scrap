open Js_of_ocaml

val debug : ('a, unit, string, unit) format4 -> 'a

val math : <
  abs : float -> float Js.meth;

  add : float -> float -> float Js.meth;

  arrayOfNumber : Js.number Js.t Js.js_array Js.t Js.meth;

  arrayOfString : Js.js_string Js.t Js.js_array Js.t Js.meth;

  increment : int Js.js_array Js.t -> int Js.js_array Js.t Js.meth;

  one : Js.number Js.t Js.meth;

  zero : float Js.readonly_prop > Js.t
