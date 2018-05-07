class ['a] stack =
  object (self)
    val mutable list = ( [] : 'a list ) (* インスタンス変数 *)

    method push x =                        (* push メソッド *)
      list <- x :: list

    method pop =                           (* pop メソッド *)
      let result = List.hd list in
      list <- List.tl list;
      result

    method peek =                          (* peek メソッド *)
      List.hd list

    method size =                          (* size メソッド *)
      List.length list
  end
