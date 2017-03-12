module type Formatter_type = sig
  val info: ('a, unit, string) format -> 'a
end
