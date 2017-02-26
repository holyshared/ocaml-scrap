module Pull = Github.Pull
module Monad = Github.Monad
module Stream = Github.Stream

(** format for pull request number *)
let string_of pull_number =
  "#" ^ (string_of_int pull_number)

(** print pull request number of github repository *)
let print_of p =
  let open Github_t in
  Monad.return (print_endline (string_of p.pull_number))

(** print all opened pull request number of github repository *)
let print_of_pull_requests ~user ~repo =
  let pull_requests = Pull.for_repo ~user ~repo ~state:`Open () in
  let print_pull_requests = Stream.iter print_of pull_requests in
  Lwt_main.run (Monad.run print_pull_requests)
