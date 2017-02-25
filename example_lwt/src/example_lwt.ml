(** simple thread *)
let simple_thread = Lwt.return "simple_thread ok!!"

(** map_thread thread *)
let map_thread =
  let root = Lwt.return "lwt map example" in
  let started_message s = "started: " ^ s in
  Lwt.map started_message root

let () =
  print_endline (Lwt_main.run simple_thread);
  print_endline (Lwt_main.run map_thread);
