(* The MIT Licence, Noritaka Horio <holy.shared.design@gmail.com> *)

open Prompt

module Generator = struct
  let run a1 a2 =
    Printf.printf "%s\n" a1;
    Printf.printf "%d\n" a2
end

module Command = struct
  let q1 () =
    Question.ask "Q1"

  let q2 () =
    Question.ask_int "Q2"

  let perform f =
    Question.(
      f
        |> next (q1 ())
        |> next (q2 ())
    )
end
