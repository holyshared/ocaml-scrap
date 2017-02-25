let read_all f =
  let ic = open_in f in
  let length_of_ic ic = in_channel_length ic in
  let read_of_file ic = really_input_string ic (length_of_ic ic) in
  let ic_close_on c = close_in ic; c in
  ic_close_on (read_of_file ic)
