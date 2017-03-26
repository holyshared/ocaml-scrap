open Lwt_main
open Lwt.Infix

module FS = Git_unix.FS
module Hash = Git_unix.Hash_IO
module Commit = Git_unix.Hash_IO.Commit
module Reference = Git.Reference

let print_commit v =
  let open Git.Commit in
  let open Git.User in
  let committer v = "commiter: " ^ v.name ^ "<" ^ v.email ^ ">" in
  print_endline (committer v.committer);
  print_endline ("message: " ^ v.message)

let print_value v =
  let open Git.Value in
  match v with
    | Commit v -> print_commit v
    | Blob _ -> print_endline "blob!!"
    | Tag _ -> print_endline "tag!!"
    | Tree _ -> print_endline "tree!!"

let master_of_commit repo =
  let read_reference = FS.read_reference_exn repo Reference.master in
  let read hash = FS.read repo hash in
  let print_for_value value =
    Lwt.return (
      match value with
        | Some v -> print_value v
        | None -> print_endline "none!!"
    ) in
  read_reference >>= read >>= print_for_value

let master ?(root=Sys.getcwd ()) () =
  let run () =
    (FS.create ~root:root ()) >>= (fun repo -> master_of_commit repo) in
  let faild exn =
    print_endline (Printexc.to_string exn);
    Lwt.return_unit in
  Lwt_main.run (Lwt.catch run faild)
