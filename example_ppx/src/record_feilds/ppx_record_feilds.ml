(*
[
  structure_item (bar.ml[1,0+0]..[4,43+19])
    Pstr_type Rec
    [
      type_declaration "t" (bar.ml[1,0+5]..[1,0+6]) (bar.ml[1,0+0]..[4,43+19])
        attribute "prefix"
          [
            structure_item (bar.ml[4,43+12]..[4,43+18])
              Pstr_eval
              expression (bar.ml[4,43+12]..[4,43+18])
                Pexp_constant PConst_string("user",None)
          ]
        ptype_params =
          []
        ptype_cstrs =
          []
        ptype_kind =
          Ptype_record
            [
              (bar.ml[2,11+2]..[2,11+15])
                Immutable
                "name" (bar.ml[2,11+2]..[2,11+6])                core_type (bar.ml[2,11+8]..[2,11+14])
                  Ptyp_constr "string" (bar.ml[2,11+8]..[2,11+14])
                  []
              (bar.ml[3,27+2]..[3,27+15])
                Immutable
                "desc" (bar.ml[3,27+2]..[3,27+6])                core_type (bar.ml[3,27+8]..[3,27+14])
                  Ptyp_constr "string" (bar.ml[3,27+8]..[3,27+14])
                  []
            ]
        ptype_private = Public
        ptype_manifest =
          None
    ]
]
*)

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
