open Js_of_ocaml

let debug f = Printf.ksprintf (fun s -> Firebug.console##log (Js.string s)) f

let math =
  (object%js
    method add x y =
      x +. y

    method abs x =
      abs_float x

    (* OCamlの型からJSの型にする必要がある *)
    method arrayOfString =
      Js.array ([|
        Js.string "aa";
        Js.string "bb";
        Js.string "cc"
      |])

    method arrayOfNumber =
      Js.array ([|
        Js.number_of_float 1.0;
        Js.number_of_float 2.0;
        Js.number_of_float 3.0;
      |])

    method increment nums =
      Js.to_array nums
        |> Array.map succ
        |> Js.array

    method one =
      Js.number_of_float 1.0

    val zero = 0.
  end)

let _ =
  Js.export "myMathLib" math
