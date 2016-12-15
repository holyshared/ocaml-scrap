open Report_t

let read_from_file file =
  let ch = open_in file in
  let length = in_channel_length ch in
  let file = really_input_string ch length in
  close_in ch;
  file

let () =
  let json = read_from_file "tests/fixtures/report.json" in
  let result = Report_j.report_of_string json in
  List.iter (fun user -> print_endline user.name) result.users
