module type S = sig
  val output_level: Log_level.t
  val coloring: bool
  val log:
      output: (string -> unit) ->
      level:Log_level.t ->
      ('a, unit, string, unit) format4 -> 'a
end

let current = ref (module struct
  include Log_writer.Color
  let coloring = true
  let output_level = Log_level.Info
end: S)

let output_level =
  let module L = (val !current) in
  L.output_level

let coloring =
  let module L = (val !current) in
  L.coloring

let log ~level fmt =
  let module L = (val !current) in
  let current_level = (Log_level.to_int (L.output_level)) in
  let output_level = (Log_level.to_int level) in
  if current_level <= output_level then
    L.log ~output:print_string ~level fmt
  else
    L.log ~output:(fun _ -> ())~level fmt

let info fmt = log ~level:Log_level.Info fmt
let debug fmt = log ~level:Log_level.Debug fmt
let error fmt = log ~level:Log_level.Error fmt
let notice fmt = log ~level:Log_level.Notice fmt
let warn fmt = log ~level:Log_level.Warning fmt
let critial fmt = log ~level:Log_level.Critial fmt
let emergency fmt = log ~level:Log_level.Emergency fmt

let make ?(level=Log_level.Info) ~coloring =
  let writer =
    if coloring then
      (module Log_writer.Color: Log_writer.S)
    else
      (module Log_writer.Text: Log_writer.S) in
  let module W = (val writer) in
  let module L = struct
    let output_level = level
    let coloring = coloring
    let log = W.log
  end in
  (module L: S)

let configure ?(level=Log_level.Info) ~coloring =
  let module L = (val make ~level ~coloring) in
  current := (module L: S)
