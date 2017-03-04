open Lwt
open Cohttp
open Cohttp_lwt_unix

(** Authorization: token OAUTH-TOKEN *)
let headers_of_api token =
  let h = Header.init () in
  Header.add h "Authorization" (token ^ " OAUTH-TOKEN")

let status_code_of_response res =
  res |> Response.status |> Code.code_of_status

let body_of_response body =
  body |> Cohttp_lwt_body.to_string

(** POST /repos/:owner/:repo/comments/:id/reactions *)
let create_commit_comment ~token ~user ~repo ~sha ~content =
  let headers = headers_of_api token in
  let uri = "/repos/" ^ user ^ "/" ^ repo ^ "/comments/" ^ sha ^ "/reactions" in
  Client.post (Uri.of_string uri) ~body:(`String content) ~headers:headers >>= fun (res, body) ->
  print_endline (string_of_int (status_code_of_response res));
  body_of_response body
