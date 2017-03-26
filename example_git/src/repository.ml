open Lwt_main
open Lwt.Infix

module FS = Git_unix.FS
module Commit = Git.Hash.Commit
module Reference = Git.Reference

let print_head hd =
  let open Commit in
  let open Reference in
  print_endline "print head start";
  match hd with
    | Hash commit -> print_endline ("commit - " ^ (Commit.to_hex commit))
    | Ref value -> print_endline ("ref - " ^ (to_raw value))

let head ?(root=Sys.getcwd ()) () =
  Lwt_main.run ((FS.create ~root:root ()) >>= (fun repo ->
    print_endline "head start1";
    FS.read_head repo) >>= fun head ->
      print_endline "head start2";
      match head with
        | Some hd -> Lwt.return (print_head hd)
        | None -> Lwt.return (print_endline "head noting"))
