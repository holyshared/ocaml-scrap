module type S = sig
  val log:
    output: (string -> unit) ->
    level:Log_level.t ->
    ('a, unit, string, unit) format4 -> 'a
end

module Color : S = struct
  let log ~output ~level fmt =
    let color_format = Log_color.color_format ~color:(Log_level.to_color level) in
    Printf.kprintf output (color_format fmt)
end

module Text : S = struct
  let log ~output ~level fmt =
    Printf.kprintf output fmt
end
