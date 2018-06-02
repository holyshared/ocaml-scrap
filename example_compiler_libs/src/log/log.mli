val output_level: Log_level.t
val coloring: bool

val info: ('a, unit, string, unit) format4 -> 'a
val debug: ('a, unit, string, unit) format4 -> 'a
val error: ('a, unit, string, unit) format4 -> 'a
val notice: ('a, unit, string, unit) format4 -> 'a
val warn: ('a, unit, string, unit) format4 -> 'a
val critial: ('a, unit, string, unit) format4 -> 'a
val emergency: ('a, unit, string, unit) format4 -> 'a

val configure: ?level:Log_level.t -> coloring:bool -> unit
