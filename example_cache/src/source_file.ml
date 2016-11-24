type 'a read_result =
  | Cache of 'a
  | File of 'a

let read_from_cache file cache =
  try Some (Cache_manager.find cache file)
    with Not_found -> None

let read_from_file file =
  let ch = open_in file in
  let length = in_channel_length ch in
  let file = really_input_string ch length in
  close_in ch;
  file
  
let rec lines_into inputs outputs i =
  let line_number = i + 1 in
  match inputs with
    | [] -> outputs
    | hd :: tl -> lines_into tl (Lines.add line_number hd outputs) line_number

let lines_from_string s =
  let outputs = Lines.empty in
  let inputs = Str.split_delim (Str.regexp "\n") s in
  lines_into inputs outputs 0

let read_from_file_and_cache file cache =
  let content = read_from_file file in
  let lines = lines_from_string content in
  Cache_manager.add cache file lines;
  lines

let read_all file cache =
  match read_from_cache file cache with
    | Some v -> Cache v
    | None -> File (read_from_file_and_cache file cache)
