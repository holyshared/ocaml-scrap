open Lwt.Infix
open Irmin_unix

module Store = Irmin_unix.Git.FS.KV (Irmin.Contents.String)

let config = Irmin_git.config ~bare:true "/tmp/irmin/test"
let info fmt = Irmin_unix.info ~author:"me <me@moi.com>" fmt

let prog =
  Store.Repo.v config >>= Store.master >>= fun t ->
  Store.set t ~info:(info "Updating foo/bar") ["foo"; "bar"] "hi!" >>= fun () ->
  Store.get t ["foo"; "bar"] >>= fun x ->
  Printf.printf "Read: %s\n%!" x;
  Lwt.return_unit

let () = Lwt_main.run prog
