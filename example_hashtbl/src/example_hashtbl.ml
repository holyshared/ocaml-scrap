open Core.Std

module Lines = Map.Make(
  struct
  type t = int
  let compare = compare
  end
)

(* Read file from cache *)
let read_file_from_cache table file =
  Hashtbl.find table file

(* Read and cache file *)
let read_file_and_cache table file =
  let content = In_channel.read_all file in
  let content = content in
  let results = Lines.empty in



  match Hashtbl.add table file content
    with `Duplicate -> content
      | `Ok -> content

(* Read the file and cache the contents read *)
let read_file table file =
  match read_file_from_cache table file
    with Some content -> content
      | None -> read_file_and_cache table file

let read_files table files =
  List.map files (fun file -> (read_file table file))






let () =
  let cache_manager = String.Table.create () in
  let contents = read_files cache_manager [ "fixtures/example1.txt"; "fixtures/example2.txt" ] in 
  let content = read_file cache_manager "fixtures/example1.txt" in 
  List.iter contents (fun content -> (print_endline content));
  print_endline content;
