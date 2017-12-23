module Method = struct
  type t = Get | Post | PUT | DELETE | HEAD
  let get = Get
end

module Path = struct
  type t = string
  let of_string s = s
end

module Handler = struct
  type t = unit -> unit
  let on f = f
  let call f = f ()
end

module Route = struct
  type t = Method.t * Path.t * Handler.t
  let create ~path ~meth handler = (meth, path, handler)
  let path t =
    let _, p, _ = t in
    p
  let on t =
    let _, _, h = t in
    h

  let eq ~meth ~path t =
    let m, p, _ = t in
    (m = meth) && (p = path)
end

let create () = []

let add ~path ~meth ~on t =
  (Route.create ~path ~meth on)::t

let resolve ~path ~meth t =
  let rec resolve_route t =
    match t with
      | [] -> None
      | hd::tail ->
        if Route.eq ~path ~meth hd then
          let _, _, h = hd in
          Some h
        else resolve_route tail in
  resolve_route t
