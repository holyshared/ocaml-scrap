open Lwt
open Cohttp
open Cohttp_lwt_unix

type t = {
  user: string;
  repo: string;
  token: string;
}

let init ~token ~user ~repo =
  { user; repo; token }

(** Authorization: token OAUTH-TOKEN *)
let headers_of_api token =
  let h = Header.init () in
  Header.add_list h [
    ("User-Agent", "holyshared");
    ("Authorization", ("token " ^ token))
  ]

let status_code_of_response res =
  res |> Response.status |> Code.code_of_status

let body_of_response body =
  body |> Cohttp_lwt_body.to_string

(** POST /repos/:owner/:repo/pulls/:number/comments *)
let create_commit_comment t ~num ~content =
  let headers = headers_of_api t.token in
  let body = Github_j.string_of_review_comment content in
  let uri = "https://api.github.com/repos/" ^ t.user ^ "/" ^ t.repo ^ "/pulls/" ^ (string_of_int num) ^ "/comments" in
  print_endline uri;
  print_endline body;
  Client.post (Uri.of_string uri) ~body:(`String body) ~headers:headers >>= fun (res, body) ->
  print_endline (string_of_int (status_code_of_response res));
  body_of_response body

let create_review_request t ~num ~content =
  let headers = headers_of_api t.token in
  let body = Github_j.string_of_review content in
  let uri = "https://api.github.com/repos/" ^ t.user ^ "/" ^ t.repo ^ "/pulls/" ^ (string_of_int num) ^ "/reviews" in
  print_endline uri;
  print_endline body;
  Client.post (Uri.of_string uri) ~body:(`String body) ~headers:headers >>= fun (res, body) ->
  print_endline (string_of_int (status_code_of_response res));
  body_of_response body
