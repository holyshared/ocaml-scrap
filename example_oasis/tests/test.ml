open OUnit2

let all_tests = "all_tests" >::: [
  Example_test.tests
]

let () =
  run_test_tt_main all_tests;;
