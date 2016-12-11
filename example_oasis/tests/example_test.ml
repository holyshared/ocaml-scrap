open OUnit2

let say_test =
  "echo string" >:: (fun _ -> assert_equal (Example.say "hello") "hello")

let tests =
  "all_tests" >::: [ say_test; ]
