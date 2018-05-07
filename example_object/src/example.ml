class ['a] stack =
  object (self)
    val mutable the_list = ( [] : 'a list ) (* インスタンス変数 *)

    method push x =                        (* push メソッド *)
      the_list <- x :: the_list

    method pop =                           (* pop メソッド *)
      let result = List.hd the_list in
      the_list <- List.tl the_list;
      result

    method peek =                          (* peek メソッド *)
      List.hd the_list

    method size =                          (* size メソッド *)
      List.length the_list
  end
