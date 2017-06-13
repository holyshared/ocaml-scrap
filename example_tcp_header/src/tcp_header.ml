type input = {
  pos_in: unit -> int;
  seek_in: int -> unit;
  input_char: unit -> char;
  in_channel_length: int;
}

type input_bits = {
  input: input;
  mutable byte: int;
  mutable bit: int;
}

let input_of_channel ch =
  {
    pos_in = (fun () -> pos_in ch);
    seek_in = seek_in ch;
    input_char = (fun () -> input_char ch);
    in_channel_length = in_channel_length ch
  }

let align b =
  b.bit <- 0

(* take 1 bit from buffer *)
let rec getbit b =
  if b.bit = 0 then
    (* 8bit position, next byte *)
    begin
      b.byte <- int_of_char (b.input.input_char ());
      b.bit <- 128;
      getbit b
    end
  else
    (* bit position is true? (1)  *)
    let r = b.byte land b.bit > 0 in
    b.bit <- b.bit / 2; (* 128, 64, 32, 16, 8, 4, 2 ... *)
    r
