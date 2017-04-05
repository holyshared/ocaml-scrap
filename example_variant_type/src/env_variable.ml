module type S = sig
  type v
  val value_of_string: string -> string -> (v, string) result
  val string_of_value: v option -> string
end
