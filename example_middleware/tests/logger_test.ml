open OUnit2
open Logger

let wrtie_to_buffer test_ctxt =
  let f = open_out "/tmp/logger_test.log" in 
  set_output f;
  debug "%s %s %s\n" "1" "2" "3";
  info "%s %s %s\n" "1" "2" "3";
  warn "%s %s %s\n" "1" "2" "3"

let tests =
  "logger_tests" >::: [
    "wrtie_to_buffer" >:: wrtie_to_buffer;
  ]
