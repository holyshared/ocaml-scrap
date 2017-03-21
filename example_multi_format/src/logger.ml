open Appender
open Formatter

type config = {
  formatter: (module Formatter_t);
  appenders: (module Appender_t) list;
}

module type Logger_t = sig
  val t: config
  val info: ('a, unit, string, unit) format4 -> 'a
end

let put appenders s =
  List.iter (fun appender ->
    let module Appender = (val appender: Appender_t) in
    Appender.put s) appenders

(*let create ~(appenders: (module Appender_t) list) ~(formatter: (module Formatter_t)) =*)
let create_logger appenders formatter =
  let module L = (struct
    let t = {
      formatter;
      appenders;
    }
    let info format =
      let module Formatter = (val t.formatter) in
      Formatter.info (fun s -> put appenders s) format
  end) in
  (module L: Logger_t)
