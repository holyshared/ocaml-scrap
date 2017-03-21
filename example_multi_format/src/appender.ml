open Formatter

type config = {
  out: out_channel;
}

module type LogAppender = sig
  val t: config
  val put: string -> unit
end

let create ~out =
  let module Appender = (struct
    let t = { out; }
    let put s = output_string t.out s
  end) in
  (module Appender: LogAppender)
