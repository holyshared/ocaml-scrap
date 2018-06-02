type t = {
  no_color: bool;
  verbose: bool;
}
val default_options: unit -> t
val is_no_color: t -> bool
val is_verbose: t -> bool
