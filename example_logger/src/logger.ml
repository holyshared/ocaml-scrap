let debug_fomatter fmt = "\027[37m" ^^ fmt ^^ "\027[0m\n"
let error_fomatter fmt = "\027[35m" ^^ fmt ^^ "\027[0m\n"

let output = ref stdout
let output_error = ref stderr
let init ?(out=stdout) ?(out_error=stderr) () =
  output := out;
  output_error := out_error
let debug fmt = Printf.ksprintf (fun s -> output_string !output s) (debug_fomatter fmt)
let error fmt = Printf.ksprintf (fun s -> output_string !output_error s) (error_fomatter fmt)
