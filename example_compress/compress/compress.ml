(* ex. [31; 31; 32; 33; 34; 34] *)
type t = int list

type packed_type =
  | Same of int * int (* value, n times *)
  | Different of int (* value only *)

type packed_stream = {
  mutable input: t;
  mutable times: int;
  mutable current: int option
}

let take_while_same t =
  let rec take_result t ~prev ~times =
    match t with
      | [] -> None
      | hd::tail ->
        if prev = hd then
          take_result t ~prev ~times:(times + 1)
        else
          Some times in
  match t with
    | [] -> None
    | hd::tail ->
      take_result t ~prev:hd ~times:0

let pack t =
  let rec take_result t ~prev ~times ~out =
    match t with
      | [] ->
        if times > 1 then
          (Same (prev, times))::out
        else
          (Different prev)::out
      | hd::tail ->
        if prev = hd then
          take_result ~times:(times + 1) ~prev:hd ~out tail
        else
          if times > 1 then
            take_result ~times:1 ~prev:hd ~out:((Same (prev, times))::out) tail
          else
            take_result ~times:1 ~prev:hd ~out:((Different prev)::out) tail
             in
  match t with
    | [] -> []
    | hd::tail ->
      List.rev (take_result t ~prev:hd ~times:0 ~out:[])

module Stream = struct
  let from v =
    match v with
      | [] ->
        { input = []; times = 0; current = None }
      | hd::tail ->
        { input = tail; times = 0; current = Some hd }

  let consume t =
    match t.current with
      | Some v ->
        if t.times >= 1 then
          Some (Same (v, t.times + 1))
        else
          Some (Different v)
      | None -> None

  let end_of_stream t =
    let r = consume t in
    t.current <- None;
    t.times <- 0;
    r

  let next t =
    let rec take t =
      let same_consume remain =
        t.input <- remain;
        t.times <- t.times + 1;
        take t in
      let stop_same_consume curr remain =
        let r = consume t in
        t.input <- remain;
        t.current <- Some curr;
        t.times <- 0;
        r in
      match t.input with
        | [] -> end_of_stream t
        | hd::tail ->
          if Some hd = t.current then
            same_consume tail
          else
            stop_same_consume hd tail
          in
    take t

end
