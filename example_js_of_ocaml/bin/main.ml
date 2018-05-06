open Js_of_ocaml

module Html = Dom_html

let addEventListener = Dom.addEventListener
let document = Html.window##.document
let domContentLoaded = Dom_events.Typ.domContentLoaded

let debug f = Printf.ksprintf (fun s -> Firebug.console##log (Js.string s)) f

let array_to_dom ~f ~parent values =
  let appendTo p c = Dom.appendChild p c; p in
  let values_to_elements values = ArrayLabels.map ~f values in
  ArrayLabels.fold_left ~f:appendTo ~init:parent (values_to_elements values)

let li_of_string text =
  let item = Html.createLi document in
  item##.textContent := Js.Opt.return text;
  item

let li_of_number num =
  let item = Html.createLi document in
  let number_to_js_string num =
    Js.float_of_number num
      |> int_of_float
      |> string_of_int
      |> Js.string in
  item##.textContent := Js.Opt.return (number_to_js_string num);
  item

let array_of_string_to_dom strs =
  let str_array = Js.to_array strs in
  let ul = Html.createUl document in
  array_to_dom ~f:li_of_string ~parent:ul str_array

let array_of_number_to_dom nums =
  let num_array = Js.to_array nums in
  let ul = Html.createUl document in
  array_to_dom ~f:li_of_number ~parent:ul num_array

let dom_content_loaded evt =
  let example_math = Example.math in
  debug "debug: %s" "domContentLoaded!!";
  debug "debug: %f" (example_math##add 1.0 2.0);
  debug "debug: %f" (example_math##one |> Js.float_of_number);
  let array_of_string_ul = array_of_string_to_dom (example_math##arrayOfString) in
  let array_of_number_ul = array_of_number_to_dom (example_math##arrayOfNumber) in
  Dom.appendChild document##.body array_of_string_ul;
  Dom.appendChild document##.body array_of_number_ul;
  Js.bool true

let () =
  debug "debug: %s" "output js!!";
  let event_handler = Dom.handler dom_content_loaded in
  ignore (addEventListener document domContentLoaded event_handler (Js.bool false))
