open Sexplib
open Conv

let is_none v =
  v = None

module Version = struct
  type t = (string * int) [@@deriving sexp]

  let key = "jbuild_version"

  let create ?(vnum=1) () =
    key, vnum

  let to_sexp = sexp_of_t
  let of_sexp = t_of_sexp

  let to_string t =
    let open Sexp_pretty in
    Pretty_print.sexp_to_string (to_sexp t)
end

module Library = struct
  type build_config = {
    name: string;
    public_name: string option [@default None] [@sexp_drop_if is_none];
    libraries: string list option [@default None] [@sexp_drop_if is_none];
  } [@@deriving sexp]

  type t = (string * build_config) [@@deriving sexp]

  let key = "library"

  let create ?public_name ?libraries name () =
    key, {
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
