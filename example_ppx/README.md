# example_ppx

## コードからASTのダンプを出力する

```shell
-ocamlc -dparsetree foo.ml 2> foo-out.dump
-ocamlc -dparsetree bar.ml 2> bar-out.dump
```

## ソースにppxを適用して出力する

```shell
ocamlc -dsource -ppx ./_build/install/default/bin/ppx_getenv foo.ml
ocamlc -dsource -ppx ./_build/install/default/bin/ppx_record_feilds bar.ml
```

## ppx_driver対応の変換機にかける

```shell
./_build/default/.ppx/ppx_example+ppx_driver.runner/ppx.exe bar.ml
```
