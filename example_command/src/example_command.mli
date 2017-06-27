val count : int Cmdliner.Term.t
val msg : string Cmdliner.Term.t
val chorus : int -> string -> [> `Ok of unit ]
val chorus_t : unit Cmdliner.Term.t
val info : Cmdliner.Term.info
