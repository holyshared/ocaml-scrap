open Router

let router () =
  let rotuer = create () in
  add ~path:(Path.of_string "/users") ~meth:Method.get ~on:(Handler.on (fun () -> print_endline "route matched")) rotuer

let () =
  let rotuer = router () in
  match resolve ~path:(Path.of_string "/users") ~meth:Method.get rotuer with
    | Some h -> Handler.call h
    | None -> print_endline "not found"
