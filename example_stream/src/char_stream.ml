open Core_stream

module Char_stream = Make(struct
  type t = char
  let next t =
    try
      Consumed (Stream.next t)
    with
      Stream.Failure -> Eof
end)

include Char_stream
