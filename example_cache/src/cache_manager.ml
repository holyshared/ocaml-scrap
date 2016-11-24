module SourceFileName = struct
  type t = string
  let equal = (=)
  let hash = Hashtbl.hash
end

module CacheManager = Hashtbl.Make(SourceFileName)

include CacheManager
