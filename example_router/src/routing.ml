module Routing_error = struct
  (* FIXME: Handler_error to HTTP Status *)
  type t =
    | Not_found
    | Handler_error of string

  let not_found = Not_found
  let handler_error s = Handler_error s

  let to_string = function
    | Not_found -> "not found"
    | Handler_error e -> e
end

module type S = sig
  val handle: meth:Http.Method.t ->
    uri:string ->
    (unit, Routing_error.t) result
end

module Make(Routes: Routes.S)(Resolver: Route_resolver.S): S = struct
  let resolver = Resolver.create Routes.routes

  let handle ~meth ~uri =
    match Resolver.resolve ~meth ~uri resolver with
      | None -> Error Routing_error.not_found
      | Some (params, handler) ->
        match handler params with
          | Ok _ -> Ok ()
          | Error e -> Error (Routing_error.handler_error e)
end
