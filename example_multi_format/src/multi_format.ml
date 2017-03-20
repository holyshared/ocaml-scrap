open Logger
open Formatter

let formatter () =
  let module F = (struct
    let info f format = Printf.ksprintf f format
  end) in
  (module F: Formatter_t)

let () =
  let module F = (val formatter ()) in
  let module L1 = (val create ~out:stdout ~formatter: (module F: Formatter_t)) in
  let module L2 = (val create ~out:stdout ~formatter: (module F: Formatter_t)) in
  L1.info "%s %s\n" "a" "b";
  L2.info "%s %s\n" "a" "b";
