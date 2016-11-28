let () =
  let open Context in
  let open Middleware in
  let open Middleware.Standard in
  let ctx = { name="ctx" } in
  match perform ~middlewares: [ middleware1; middleware2 ] ~context: ctx with
    | Ok _ -> print_endline "ok"
    | Error e ->
      let (code, message) = e in
      print_endline ("err: " ^ (string_of_int code) ^ ", " ^ message)
