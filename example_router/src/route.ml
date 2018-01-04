type t = Http.Method.t * Pattern.t

let post uri = (Http.Method.post, uri)
let put uri = (Http.Method.put, uri)
let get uri = (Http.Method.get, uri)

let resolve ~meth ~uri t =
  let m, p = t in
  match Pattern.resolve p uri with
    | Some v ->
      if (m = meth) then Some (Route_params.from v)
      else None
    | None -> None
