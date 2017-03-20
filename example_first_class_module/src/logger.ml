(** logger config *)
type config = {
  output: out_channel
}

(** logger module signiture *)
module type Logger_t = sig
  val t: config
  val info: ('a, out_channel, unit) format -> 'a
end

let create out =
  let config = { output=out } in
  let module Logger = (struct
    let t = config
    let info format = Printf.fprintf t.output format
  end) in
  (module Logger: Logger_t)
