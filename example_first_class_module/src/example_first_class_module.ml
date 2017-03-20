let console_logger () =
  let module Log = (val Logger.create stdout) in
  Log.info "%s %s %s\n" "1" "2" "3";
  (module Log: Logger.Logger_t)

let file_logger () =
  let module Log = (val Logger.create stdout) in
  Log.info "%s %s %s\n" "1" "2" "3";
  (module Log: Logger.Logger_t)

let () =
  let loggers = [
    (console_logger ());
    (file_logger ())
  ] in
  List.iteri (fun i (logger: (module Logger.Logger_t)) ->
    let module Logger = (val logger) in
    Logger.info "order_number: %d\n" i
  ) loggers
