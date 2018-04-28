(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

open Prompt

module Generator = struct
  let run a1 a2 a3 =
    Printf.printf "%s\n" a1;
    Printf.printf "%d\n" a2;
    match a3 with
      | None -> print_endline "none"
      | Some v -> Printf.printf "%d\n" v
end

module Command = struct
  let q1 () =
    Question.ask_require "Require question"

  let q2 () =
    Question.ask_int "Required integer question"

  let q3 () =
    Question.ask_opt_int "Required optional integer question"

  let perform f =
    Question.(
      f
        |> next (q1 ())
        |> next (q2 ())
        |> next (q3 ())
    )
end
