open Core_stream

module Char_stream = Make(struct
  type t = char
  let next t =
    try
      Consumed (Stream.next t)
    with
      Stream.Failure -> Eof None
end)

include Char_stream
