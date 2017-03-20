open Formatter

type config = {
  out: out_channel;
  formatter: (module Formatter_t);
}

module type Logger_t = sig
  val t: config
  val info: ('a, unit, string, unit) format4 -> 'a
end

let create ~out ~(formatter: (module Formatter_t)) =
  let module Logger = (struct
    let t = {
      out;
      formatter;
    }
    let info format =
      let module Formatter = (val t.formatter) in
      Formatter.info (fun s -> output_string t.out s) format
  end) in
  (module Logger: Logger_t)
