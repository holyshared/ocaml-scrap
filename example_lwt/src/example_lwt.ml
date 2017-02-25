(** simple thread *)
let simple_thread = Lwt.return "simple_thread ok!!"

(** map_thread thread *)
let map_thread =
  let root = Lwt.return "lwt map example" in
  let started_message s = "started: " ^ s in
  Lwt.map started_message root

(** multi_thread *)
let multi_threads =
  let tasks = [
    Lwt.return "thread - 1";
    Lwt.return "thread - 2";
    Lwt.return "thread - 3";
  ] in
  Lwt.nchoose tasks

let () =
  print_endline (Lwt_main.run simple_thread);
  print_endline (Lwt_main.run map_thread);
  List.iter (fun s -> print_endline s) (Lwt_main.run mulit_threads)
