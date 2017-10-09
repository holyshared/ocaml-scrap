module S = Compress.Stream

let pack = Compress.pack

let print_result v =
  match v with
    | Compress.Same (value, times) ->
      print_endline ("same: " ^ (string_of_int value) ^ " ~times: " ^ (string_of_int times))
    | Compress.Different v ->
      print_endline ("different: " ^ (string_of_int v))

let packed_all () =
  print_endline "packed_all";
  ListLabels.iter ~f:print_result (pack [31; 31]);
  ListLabels.iter ~f:print_result (pack [31; 31; 31]);
  ListLabels.iter ~f:print_result (pack [31; 31; 31; 31]);
  ListLabels.iter ~f:print_result (pack [31; 32]);
  ListLabels.iter ~f:print_result (pack [31; 32; 33; 33; 33]);
  ListLabels.iter ~f:print_result (pack [31; 32; 33; 33; 33; 31; 32])

let packed_stream_all v =
  let open Compress in
  let rec consume_all s =
    match S.next s with
      | Some v ->
        begin
          print_result v;
          consume_all s
        end
      | None -> print_endline "end" in
  consume_all (S.from v)

let packed_stream () =
  print_endline "packed_stream";
  packed_stream_all  [31; 31; 31];
  packed_stream_all  [31; 31; 31; 32];
  packed_stream_all  [31; 31; 31; 32; 33; 33]

let () =
  packed_all ();
  packed_stream ()
