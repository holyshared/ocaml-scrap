open Js_of_ocaml

module Html = Dom_html

let addEventListener = Dom.addEventListener
let document = Html.window##.document
let domContentLoaded = Dom_events.Typ.domContentLoaded

let debug f = Printf.ksprintf (fun s -> Firebug.console##log (Js.string s)) f

let dom_content_loaded evt =
  debug "debug: %s" "domContentLoaded!!";
  debug "debug: %f" (Example.math##add 1.0 2.0);
  Js.bool true

let () =
  debug "debug: %s" "output js!!";
  let event_handler = Dom.handler dom_content_loaded in
  ignore (addEventListener document domContentLoaded event_handler (Js.bool false))
