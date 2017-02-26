module Pull = Github.Pull
module Monad = Github.Monad
module Stream = Github.Stream

(** format for pull request number *)
let string_of pull_number =
  "#" ^ (string_of_int pull_number)

(** print pull request number of github repository *)
let print_of p =
  Monad.return (print_endline (string_of p))

let number_of p =
  let open Github_t in
  Monad.return [p.pull_number]

let pull_requests ~user ~repo =
  let results = Pull.for_repo ~user ~repo ~state:`Open () in
  Stream.map number_of results

(** print all opened pull request number of github repository *)
let print_of_pull_requests ~user ~repo =
  let number_of_stream = pull_requests ~user ~repo in
  let print_pull_requests = Stream.iter print_of number_of_stream in
  Lwt_main.run (Monad.run print_pull_requests)
