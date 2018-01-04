(* FIXME: Handler_error to HTTP Status *)
type routing_error =
  | Not_found
  | Handler_error of string

module type S = sig
  val handle: meth:Http.Method.t ->
    uri:string ->
    (unit, routing_error) result
end

module Make(Routes: Routes.S)(Resolver: Route_resolver.S): S = struct
  let resolver = Resolver.create Routes.routes

  let handle ~meth ~uri =
    match Resolver.resolve ~meth ~uri resolver with
      | None -> Error Not_found
      | Some (params, handler) ->
        match Handler.call ~params handler with
          | Ok _ -> Ok ()
          | Error e -> Error (Handler_error e)
end
