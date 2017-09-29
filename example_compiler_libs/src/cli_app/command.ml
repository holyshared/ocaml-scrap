module type S = sig
  val name: string
  val description: string
  val run: gopts: Global_options.t -> unit -> unit
end
