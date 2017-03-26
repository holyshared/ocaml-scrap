open OUnit2

let test_commit _ =
  print_endline "test_commit";
  Repository.master ~root:"/Users/holyshared/Documents/projects/ocaml-scrap" ();
  assert_equal "ok?" "ok?"

let tests = "all_tests" >::: [
  "test_commit" >:: test_commit
]
