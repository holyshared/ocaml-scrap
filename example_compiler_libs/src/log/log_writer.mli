module type S = sig
  val log:
    output: (string -> unit) ->
    level:Log_level.t ->
    ('a, unit, string, unit) format4 -> 'a
end

module Text : S
module Color : S
