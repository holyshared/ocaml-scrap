open Lwt_main
open Lwt.Infix

module FS = Git_unix.FS
module Hash = Git_unix.Hash_IO
module Commit = Git_unix.Hash_IO.Commit
module Reference = Git.Reference

let print_value v =
  let open Git.Value in
  let open Git.Commit in
  match v with
    | Commit v -> print_endline ("commit!! " ^ v.message)
    | Blob _ -> print_endline "blob!!"
    | Tag _ -> print_endline "tag!!"
    | Tree _ -> print_endline "tree!!"

let master_commit ?(root=Sys.getcwd ()) ?(level=6) () =
    FS.create ~root:root ~level () >>=
    (fun repo ->
      FS.read_reference_exn repo Reference.master >>= (fun hash -> FS.read repo hash)
    ) >>= (fun value ->
      let a = match value with
        | Some v -> print_value v
        | None -> print_endline "none!!" in
      Lwt.return a
    )

let master ?(root=Sys.getcwd ()) () =
  Lwt_main.run (
    Lwt.catch (fun () -> master_commit ~root ()) (fun exn -> print_endline (Printexc.to_string exn); Lwt.return_unit)
  )
