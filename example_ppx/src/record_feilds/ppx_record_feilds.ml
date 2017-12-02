open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let with_prefix ~prefix label_declarations =
  let prefix_with = ListLabels.map ~f:(fun label ->
      let pld_name = label.pld_name in
      { label with
        pld_name = {
          pld_name with txt = (prefix ^ "_" ^ pld_name.txt)
        } }
    ) label_declarations in
  Ptype_record prefix_with

let type_record_feilds_mapper argv =
  {
    default_mapper with
    type_declaration = (fun mapper type_declaration ->
        match type_declaration with
        | {
          ptype_kind = Ptype_record label_declarations;
          ptype_attributes = (_, PStr (({
              pstr_desc = Pstr_eval (({
                  pexp_desc = Pexp_constant (Pconst_string (prefix, None))
                }), _)})::[]))::[]
        } ->
          { type_declaration with
            ptype_kind = (with_prefix ~prefix label_declarations) }
        | _ -> type_declaration
      )
  }

let () = register "record_feilds" type_record_feilds_mapper
