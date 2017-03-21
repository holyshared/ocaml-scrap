open Formatter

type appender_config = {
  out: out_channel;
}

module type Appender_t = sig
  val t: appender_config
  val put: string -> unit
end

let create ~out =
  let module Appender = (struct
    let t = { out; }
    let put s = output_string t.out s
  end) in
  (module Appender: Appender_t)
