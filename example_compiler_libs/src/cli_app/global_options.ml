type t = {
  no_color: bool;
  verbose: bool;
}

let default_options () =
  {
    no_color = false;
    verbose = false;
  }

let is_no_color opts =
  opts.no_color = true

let is_verbose opts =
  opts.verbose = true
