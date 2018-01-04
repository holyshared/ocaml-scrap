open Router

module Routes = struct
  let user_index = Route.get (Pattern_builder.(pattern (root $ const "users")))
  let user_show = Route.get (Pattern_builder.(pattern (root $ const "users" $ digits "id")))
  let user_update = Route.put (Pattern_builder.(pattern (root $ const "users" $ digits "id")))
end

module User_actions = struct
  let debug_id params =
    match Route_params.vint ~key:"id" params with
      | Some v -> print_endline ("id: " ^ (string_of_int v))
      | None -> ()

  let index params =
    Ok (print_endline "user_index matched")

  let show params =
    debug_id params;
    Ok (print_endline "user_show matched")

  let update params =
    debug_id params;
    Ok (print_endline "user_update matched")
end

module Linear_resolver = Route_resolver.Linear_resolver

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
                ignore (Handler.call ~params handler);
                resolve tail
              end in
    resolve patterns
end

let default_resolver () =
  let route_handlers = [
    Route_handler.on Routes.user_index User_actions.index;
    Route_handler.on Routes.user_show User_actions.show;
    Route_handler.on Routes.user_update User_actions.update
  ] in
  let resolver = Linear_resolver.create route_handlers in
  Test_pattern.test resolver

let () =
  default_resolver ()
