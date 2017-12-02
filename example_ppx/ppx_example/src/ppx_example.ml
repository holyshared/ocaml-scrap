open Ppx_core

module Attr = struct
  let payload =
    Ast_pattern.(
      single_expr_payload (estring __)
    )

  let prefix = Attribute.declare "prefix" Type_declaration payload (fun x -> x)
end

module Record_declaration = struct
  let to_label_declarations = function
    | Ptype_record lds -> lds
    | _ -> []

  let to_prefix_type_name ~loc td =
    Loc.make ~loc (td.ptype_name.txt ^ "_prefix")

  let with_prefix ~prefix label_declarations =
    let prefix_decl prefix label =
      let pld_name = label.pld_name in
      { label with
        pld_name = {
          pld_name with txt = (prefix ^ "_" ^ pld_name.txt)
        } } in
    let prefix_with = Caml.ListLabels.map ~f:(prefix_decl prefix) label_declarations in
    Ptype_record prefix_with

  let prefix_feilds_type_declaration ~loc td =
    let module B = (val (Ast_builder.make loc): Ast_builder.S) in
    B.type_declaration
      ~name:(to_prefix_type_name ~loc td)
      ~params:td.ptype_params
      ~cstrs:td.ptype_cstrs
      ~private_:td.ptype_private
      ~manifest:td.ptype_manifest

  let record_of_td ~loc ~prefix td =
    let module B = (val (Ast_builder.make loc): Ast_builder.S) in
    let label_declarations = to_label_declarations td.ptype_kind in
    let prefix_with_decl = prefix_feilds_type_declaration ~loc td in
    let prefix_record_type = with_prefix ~prefix label_declarations in
    prefix_with_decl ~kind:prefix_record_type

  let prefix ~loc packed_tds =
    let rec prefix_all ~loc packed_tds =
      match packed_tds with
        | [] -> []
        | hd::tail ->
          let (p, td) = hd in
          (record_of_td ~loc ~prefix:p td)::(prefix_all ~loc tail) in
    prefix_all ~loc packed_tds

  let with_prefix ~loc ~rec_flag packed_tds =
    let module B = (val (Ast_builder.make loc): Ast_builder.S) in
    B.(pstr_type rec_flag (prefix ~loc packed_tds))
end

let expand_str_type_decls ~loc ~path rec_flag tds values =
  let pack prefix td =
    match prefix with
      | Some v -> (v, td)
      | None -> ("_", td) in
  let pack_map tds values = Caml.ListLabels.map2 ~f:pack values tds in
  (Record_declaration.with_prefix ~loc ~rec_flag (pack_map tds values))::[]

let () =
  Ppx_driver.register_transformation "prefix"
    ~rules: [
      Context_free.Rule.attr_str_type_decl Attr.prefix expand_str_type_decls
    ]
