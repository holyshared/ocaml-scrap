open Sexplib
open Conv

module Version = struct
  type t = (string * int) [@@deriving sexp]

  let create ?(vnum=1) () =
    "jbuild_version", vnum

  let to_sexp = sexp_of_t
  let of_sexp = t_of_sexp

  let to_string t =
    let open Sexp_pretty in
    Pretty_print.sexp_to_string (to_sexp t)
end

module Library = struct
  type build_config = {
    name: string;
    public_name: string option;
    libraries: string list option;
  } [@@deriving sexp]

  type t = (string * build_config) [@@deriving sexp]

  let create ?public_name ?libraries name () =
    "library", {
      name;
      public_name;
      libraries;
    }
  let to_sexp = sexp_of_t
  let of_sexp = t_of_sexp
  let to_string t =
    let open Sexp_pretty in
    Pretty_print.sexp_to_string (to_sexp t)
end
