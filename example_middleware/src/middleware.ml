type error = int * string

type 'a middleware_result =
  | Next
  | Done
  | Error of 'a

type ('a, 'b) middleware = 'a -> 'b middleware_result

module Standard = struct
  let middleware1 ctx =
    let open Context in
    print_endline ("start middleware1: " ^ ctx.name);
    Next

  let middleware2 ctx =
    let open Context in
    print_endline ("start middleware2: " ^ ctx.name);
    Next
end

let rec perform ~middlewares: middlewares ~context: ctx =
  match middlewares with
    | [] -> Ok ()
    | middleware :: remain_middlewares ->
      match middleware ctx with
        | Next -> perform remain_middlewares ctx
        | Done -> Ok ()
        | Error v -> Error v
