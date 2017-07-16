module type S = sig
  val name: string
  val short_desc: string
  val parse_args: unit -> unit
  val run: unit -> unit
end
