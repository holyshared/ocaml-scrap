open Log

let task ?(name="default") () =
  info "Task start: %s\n" name;
  debug "debug message1\n";
  debug "debug message2\n";
  info "Task end\n";
