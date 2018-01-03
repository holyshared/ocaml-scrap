module type S = sig
  type t
  val create: Routes.t -> t
  val resolve: meth:Http.Method.t
    -> uri:string
    -> t
    -> ((string * string) list * Handler.t) option
end

module Default_route_resolver : S = struct
  type t = Routes.t

  let create routes = routes

  let resolve ~meth ~uri t =
    let rec resolve_from routes =
      match routes with
        | [] -> None
        | hd::tail ->
          let r, h = hd in
          match Route.resolve ~meth ~uri r with
            | Some v -> Some (v, h)
            | None -> resolve_from tail in
    resolve_from t
end
