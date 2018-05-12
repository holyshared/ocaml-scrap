open Js_of_ocaml

let num_op = (object%js
  method increment nums =
    let add_one n = (Js.float_of_number n) +. 1.0
      |> Js.number_of_float in
    Js.array_map add_one nums
end)

let _ =
  Js.export "num_op" num_op
