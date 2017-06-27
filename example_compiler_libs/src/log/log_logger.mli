module type S = sig
  val output_level: Log_level.t
  include Log_writer.S
end
