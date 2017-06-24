open Tcp_header

let () =
  let header = parse "tests/fixtures/tcp_header.byte" in
  print_endline (string_of_int header.src_port);
  print_endline (string_of_int header.dest_port);
  print_endline (string_of_int header.seq_number);
  print_endline (string_of_int header.ack_number);
  print_endline (string_of_bool header.urgent);
  print_endline (string_of_bool header.ack);
  print_endline (string_of_bool header.push);
  print_endline (string_of_bool header.reset);
  print_endline (string_of_bool header.syn);
  print_endline (string_of_bool header.fin);
  print_endline (string_of_int header.window_size);
  print_endline (string_of_int header.checksum);
  print_endline (string_of_int header.urgent_pointer);
