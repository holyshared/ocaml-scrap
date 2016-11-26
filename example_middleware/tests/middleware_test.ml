open OUnit2
open Context
open Middleware

exception Not_done

let string_of_err err =
  let (code, message) = err in
  (string_of_int code) ^ ": " ^ message

let middleware_chain test_ctxt =
  let middleware1 ctx = Next in
  let middleware2 ctx = Next in
  let ctx = { name="ctx" } in
  let result = perform ~middlewares: [ middleware1; middleware2 ] ~context: ctx in

  match result with
    | Ok _ -> ()
    | Error e -> assert_failure (string_of_err e)

let middleware_done test_ctxt =
  let middleware1 ctx = Next in
  let middleware2 ctx = Done in
  let middleware3 ctx = raise Not_done in
  let ctx = { name="ctx" } in
  let result = perform ~middlewares: [ middleware1; middleware2; middleware3 ] ~context: ctx in

  match result with
    | Ok _ -> ()
    | Error e -> assert_failure (string_of_err e)

let middleware_error test_ctxt =
  let middleware1 ctx = Next in
  let middleware2 ctx = Error (-1, "failed") in
  let ctx = { name="ctx" } in
  let result = perform ~middlewares: [ middleware1; middleware2 ] ~context: ctx in
  match result with
    | Ok _ -> assert_failure "oops!!"
    | Error e ->
      let (code, message) = e in
      assert_equal (-1) code;
      assert_equal "failed" message

let tests =
  "middleware_tests" >::: [
    "middleware_chain" >:: middleware_chain;
    "middleware_done" >:: middleware_done;
    "middleware_error" >:: middleware_error;
  ]
