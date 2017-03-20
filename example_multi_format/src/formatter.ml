open Printf

let info f format = ksprintf f format

module type Formatter_t = sig
  val info : (string -> 'd) -> ('a, unit, string, 'd) format4 -> 'a
end
