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

let try_read_file f =
  let read_all f = File_reader.read_all f in
  try
    Lwt.return (read_all f)
  with
    | e -> Lwt.fail e

let try_multi_thread_file_reads files =
  let tasks_of files = List.map (fun f -> try_read_file f) files in
  Lwt.nchoose (tasks_of files)

let to_list = function
  | Ok v -> v
  | Error e -> print_endline (Printexc.to_string e); []

let try_read_of files =
  let read_all () = Lwt.bind (try_multi_thread_file_reads files) Lwt.return_ok in
  let rescue_exception e = Lwt.return_error e in
  let try_action = Lwt.catch read_all rescue_exception in
  to_list (Lwt_main.run try_action)

let () =
  print_endline (Lwt_main.run simple_thread);
  print_endline (Lwt_main.run map_thread);
  List.iter (fun s -> print_endline s) (Lwt_main.run multi_threads);
  List.iter (fun s -> print_endline s) (try_read_of ["fixtures/file1.txt"; "fixtures/file2.txt"; "fixtures/file3.txt"])
