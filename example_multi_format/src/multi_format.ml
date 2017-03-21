open Logger
open Formatter

let formatter () =
  let module F = (struct
    let info f format = Printf.ksprintf f format
  end) in
  (module F: Formatter_t)

let appender out = Appender.create out

let appenders outputs =
  List.map (fun o -> appender o) outputs

let put appenders s =
  List.iter (fun appender ->
    let module Appender = (val appender: Appender.LogAppender) in
    Appender.put s) appenders

(*
let f (logger: (module Logger_t)) =
  let module Logger = (val logger) in
  Logger.info "%s %s\n" "a" "b"

let f2 format =
  fun (logger: (module Logger_t)) ->
    let module Logger = (val logger) in
    Logger.info format

let f3 loggers format =
  let ls = List.map (fun (logger: (module Logger_t)) ->
    fun format ->
      let module Logger = (val logger) in
      Logger.info format
  ) loggers in
  fun format ->
    List.iter (fun f -> f format) ls
*)
(*
  fun (logger: (module Logger_t)) ->
    let module Logger = (val logger) in
    Logger.info format
*)

let f3 loggers format =
  List.map (fun (logger: (module Logger_t)) ->
    let module Logger = (val logger) in
    Logger.info format
  ) loggers

let f2 loggers format =
  List.iter (fun (logger: (module Logger_t)) ->
    let module Logger = (val logger) in
    Logger.info format
  ) loggers

(*
module type MultiLogger = sig
  val loggers: (module Logger_t) list
  val info: ('a, unit, string, unit) format4 -> 'a
end
*)

let () =
  let module F = (val formatter ()) in
  let module L1 = (val create ~out:stdout ~formatter: (module F: Formatter_t)) in
  let module L2 = (val create ~out:stdout ~formatter: (module F: Formatter_t)) in
  let module A1 = (val appender stdout) in
  let module A2 = (val appender stdout) in
  let loggers = [(module L1: Logger_t); (module L2: Logger_t)] in

  let a = f3 loggers "%s %s\n" in
  List.iter (fun f -> f "d" "f") a;

  A1.put "aaa";

  put [(module A1: Appender.LogAppender); (module A1: Appender.LogAppender)] "aaaa";

(*
  f2 loggers "%s %s\n" "d" "f";
*)
  print_endline "end"

    (* let aa = f3 loggers in *)
(*  let d = f2 "%s %s\n" "a" "b" in *)

(*
  L1.info "%s %s\n" "a" "b";
  L2.info "%s %s\n" "a" "b";

  List.iter (fun (logger: (module Logger_t)) ->
    let module Logger = (val logger) in
    Logger.info "%s %s\n" "a" "b"
  ) loggers;

  List.iter (fun f -> f "%s %s\n" "a" "b") aa;
*)
  (*
  let a = f3 loggers "%s %s\n" in
  a "d" "d"
  *)

