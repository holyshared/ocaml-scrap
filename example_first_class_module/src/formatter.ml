(** Formatter module signiture *)
module type Formatter_type = sig
  val info: ('a, unit, string) format -> 'a
end

(** PrintFormatter module signiture *)
module type PrintFormatter_type = sig
  val info: ('a, out_channel, unit) format -> 'a
end

module type OuputFormatter_type = sig
  val t: out_channel
  val info: ('a, out_channel, unit) format -> 'a
end
