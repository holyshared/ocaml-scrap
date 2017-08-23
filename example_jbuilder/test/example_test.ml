open OUnit2
open Example

let test_example ctx =
  assert_equal (say_hello ()) "hello"

let tests = "all_tests" >::: [
  ("test_example" >:: test_example)
]
