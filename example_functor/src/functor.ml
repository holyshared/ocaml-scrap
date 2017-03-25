module type F = sig
  val put: string -> unit
end

module Make(F: F) = struct
  type t = { name: string }
  let create name = { name; }
  let show t = F.put t.name
end

module T = Make(struct
  let put s = print_endline s
end)

include T
