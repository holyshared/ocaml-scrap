let () =
  Logger.init ~out:stdout ~out_error:stderr ();
  Logger.debug "%s %s %s" "a" "b" "c";
  Logger.error "%s %s %s" "a" "b" "c";
  Logger.debug "%s %s %s %s" "a" "b" "c" "d";
  Logger.error "%s %s %s %s" "a" "b" "c" "d";
