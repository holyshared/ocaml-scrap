open OUnit2

let all_tests = "all_tests" >::: [
  Middleware_test.tests;
  Logger_test.tests;
]

let () =
  run_test_tt_main all_tests;;
