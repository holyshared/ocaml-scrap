open Router

module User = struct
  module Routes = struct
    let index handler =
      let route = Route.get (Pattern_builder.(pattern (root $ const "users"))) in
      Route.on route handler

    let show handler =
      let route = Route.get (Pattern_builder.(pattern (root $ const "users" $ digits "id"))) in
      Route.on route handler

    let update handler =
      let route = Route.put (Pattern_builder.(pattern (root $ const "users" $ digits "id"))) in
      Route.on route handler
  end

  module Actions = struct
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

  let routes =
    Route.([
      Routes.index Actions.index;
      Routes.show Actions.index;
      Routes.update Actions.update;
    ])
end

module Http_routing = Routing.Make (User) (Route_resolver.Linear_resolver)


module Test_pattern = struct
  let patterns = [
    (Http.Method.get, "/users");
    (Http.Method.get, "/users/1");
    (Http.Method.put, "/users/1")
  ]

  let test router =
    let module Router = (val router: Routing.S) in

    let rec resolve patterns =
      match patterns with
        | [] -> ()
        | hd::tail ->
          let meth, uri = hd in
          print_endline "uri------";
          print_endline uri;
          match Router.handle ~meth ~uri with
            | Ok _ -> resolve tail
            | Error e ->
              begin
                print_endline (Routing.Routing_error.to_string e);
                resolve tail
              end in
    resolve patterns
end

let () =
  Test_pattern.test (module Http_routing: Routing.S)
