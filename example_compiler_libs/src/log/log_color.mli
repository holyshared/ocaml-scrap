type t = Misc.Color.color

val start_with: start:('a, 'b, 'c, 'd, 'e, 'f) format6 ->
  fmt:('f, 'b, 'c, 'e, 'g, 'h) format6 ->
  ('a, 'b, 'c, 'd, 'g, 'h) format6

val color_format: color:t ->
  fmt:('a, 'b, 'c, 'd, 'e, 'f) format6 ->
  ('a, 'b, 'c, 'd, 'e, 'f) format6
