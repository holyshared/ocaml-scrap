open Router

module Routes = struct
  let user_index = Route.get (Pattern_builder.(pattern (root $ const "users")))
  let user_show = Route.get (Pattern_builder.(pattern (root $ const "users" $ digits "id")))
  let user_update = Route.put (Pattern_builder.(pattern (root $ const "users" $ digits "id")))
end

module Linear_resolver = Route_resolver.Default_route_resolver

module Test_pattern = struct
  let patterns = [
    (Http.Method.get, "/users");
    (Http.Method.get, "/users/1");
    (Http.Method.put, "/users/1")
  ]

  let test resolver =
    let rec resolve patterns =
      match patterns with
        | [] -> ()
        | hd::tail ->
          let meth, uri = hd in
          print_endline "uri------";
          print_endline uri;
          match Linear_resolver.resolve ~meth ~uri resolver with
            | None ->
              begin
                print_endline "not found";
                resolve tail
              end
            | Some (params, handler) ->
              begin
                Handler.call ~params handler;
                resolve tail
              end in
    resolve patterns
end

let default_resolver () =
  let route_handlers = [
    Route_handler.on Routes.user_index (fun s -> print_endline "user_index matched");
    Route_handler.on Routes.user_show (fun s -> print_endline "user_show matched");
    Route_handler.on Routes.user_update (fun s -> print_endline "user_update matched")
  ] in
  let resolver = Linear_resolver.create route_handlers in
  Test_pattern.test resolver

let () =
  default_resolver ()
