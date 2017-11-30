(*

[
  structure_item (bar.ml[1,0+0]..[3,27+1])
    Pstr_type Rec
    [
      type_declaration "t" (bar.ml[1,0+5]..[1,0+6]) (bar.ml[1,0+0]..[3,27+1])
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
          pld_name with txt = (prefix ^ pld_name.txt)
        } }
  ) label_declarations in
  Ptype_record prefix_with

let type_record_feilds_mapper argv =
  {
    default_mapper with
      type_declaration = (fun mapper type_declaration ->
        match type_declaration with
          | { ptype_kind = Ptype_record label_declarations } ->
            { type_declaration with
              ptype_kind = (with_prefix ~prefix:"a_" label_declarations) }
          | x -> type_declaration
      )
  }

let () = register "record_feilds" type_record_feilds_mapper
