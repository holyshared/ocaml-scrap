open Js_of_ocaml

module Html = Dom_html

let document = Html.window##.document
let addEventListener = Dom.addEventListener
let domContentLoaded = Dom_events.Typ.domContentLoaded

let debug f = Printf.ksprintf (fun s -> Firebug.console##log (Js.string s)) f

let dom_content_loaded evt =
  debug "debug: %s" "domContentLoaded!!";
  Js.bool true

let () =
  let event_handler = Dom.handler dom_content_loaded in
  ignore (addEventListener document domContentLoaded event_handler (Js.bool false))
