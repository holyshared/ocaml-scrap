module LineNumber = struct
  type t = int
  let compare = compare
end

module Lines = Map.Make(LineNumber)

include Lines
