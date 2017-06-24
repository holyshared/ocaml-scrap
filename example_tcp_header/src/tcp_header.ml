type tcp_header = {
  src_port: int;
  dest_port: int;
  seq_number: int;
  ack_number: int;
  data_offset: int;
  receive: int;
  urgent: bool;
  ack: bool;
  push: bool;
  reset: bool;
  syn: bool;
  fin: bool;
  window_size: int;
  checksum: int;
  urgent_pointer: int;
}

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

let input_bits_of_input i =
  {
    input = i;
    byte = 0;
    bit = 0
  }

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

let getval b n =
  if n <= 0 || n > 31 then
    raise (Invalid_argument "getval")
  else
    let r = ref 0 in
    for x = n - 1 downto 0 do
      r := !r lor ((if getbit b then 1 else 0) lsl x)
    done;
    !r

let getval_32 b n =
  if n <= 0 || n > 32 then
    raise (Invalid_argument "getval")
  else
    let r = ref 0 in
    for x = n - 1 downto 0 do
      r := !r lor ((if getbit b then 1 else 0) lsl x)
    done;
    !r

let input_bits_of_file f =
  let channel = open_in_bin f in
  let input = input_of_channel channel in
  input_bits_of_input input

let parse f =
  let input = input_bits_of_file f in
  let src_port = getval input 16 in
  let dest_port = getval input 16 in
  let seq_number = getval_32 input 32 in
  let ack_number = getval_32 input 32 in
  let data_offset = getval input 4 in
  let receive = getval input 6 in
  let urgent = getbit input in
  let ack = getbit input in
  let push = getbit input in
  let reset = getbit input in
  let syn = getbit input in
  let fin = getbit input in
  let window_size = getval input 16 in
  let checksum = getval input 16 in
  let urgent_pointer = getval input 16 in
  {
    src_port;
    dest_port;
    seq_number;
    ack_number;
    data_offset;
    receive;
    urgent;
    ack;
    push;
    reset;
    syn;
    fin;
    window_size;
    checksum;
    urgent_pointer;
  }
