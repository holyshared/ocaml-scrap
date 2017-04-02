module type S = sig
  type v
  type vr = (v, string) result
  type vo = v option
  val value_of_string: string -> string -> vr
  val string_of_variable: vo -> string
end
