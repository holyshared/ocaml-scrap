(*open Formatter
open Appender*)

let formatter () =
  let module F = (struct
    let info f format = Printf.ksprintf f format
  end) in
  (module F: Formatter.Formatter_t)

let appender out = Appender.create out
let appenders outputs = List.map (fun o -> appender o) outputs

let () =
  let module F = (val formatter ()) in
  let module A1 = (val Appender.create stdout: Appender.Appender_t) in
  let module A2 = (val Appender.create stdout: Appender.Appender_t) in
  let module Log = (val Logger.create_logger (appenders [stdout; stdout]) (module F: Formatter.Formatter_t)) in
  Log.info "%s %s" "1" "2"
