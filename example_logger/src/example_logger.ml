type logger = {
  debug: (string -> unit);
  error: (string -> unit);
}

let create ?(o=stdout) ?(e=stderr) () =
  let debug s = output_string o s in
  let error s = output_string e s in
  { debug=debug; error=error }

let () =
  let logger = create () in
  logger.debug "ok!!"
