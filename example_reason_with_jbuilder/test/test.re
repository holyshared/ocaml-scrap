open OUnit2;

let () =
  run_test_tt_main ("all_tests" >::: [ Example_test.tests ])
  
