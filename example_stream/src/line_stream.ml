open Core_stream

module Line_stream = Make(struct
  type t = string
  let stop_if_crlf v ~out ~stop ~continue =
    if v = '\n' then
      stop out
    else
      continue v
  let next t =
    let to_consumed buf = Consumed (Buffer.contents buf) in
    let eof buf = if (Buffer.length buf) <= 0 then
        Eof
      else
        Consumed (Buffer.contents buf) in
    let rec next_line t ~buf =
      let add_char_to_buffer v =
        Buffer.add_char buf v;
        next_line t ~buf in
      match Char_stream.next t with
        | Eof -> eof buf
        | Consumed v ->
          stop_if_crlf v ~out:buf ~stop:to_consumed ~continue:add_char_to_buffer in
    next_line t ~buf:(Buffer.create 1024)
end)

include Line_stream
