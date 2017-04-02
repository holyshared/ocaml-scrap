module type S = sig
  val pick: string -> string option
end

let pick name =
  try
    Some (Sys.getenv name)
  with e -> None
