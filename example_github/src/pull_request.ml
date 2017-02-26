module Pull = Github.Pull
module Monad = Github.Monad
module Stream = Github.Stream

let string_of pull_number =
  let open Github_t in
  "#" ^ (string_of_int pull_number)

let print_of p =
  let open Github_t in
  Monad.return (print_endline (string_of p.pull_number))

let print_of_pull_requests ~user ~repo =
  let open Github_t in
  let pull_requests = Pull.for_repo ~user ~repo ~state:`Open () in
  let print_pull_requests = Stream.iter print_of pull_requests in
  Lwt_main.run (Monad.run print_pull_requests)
