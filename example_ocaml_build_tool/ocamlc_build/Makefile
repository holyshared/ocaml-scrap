#
# 1. モジュールをコンパイルする
# 2. コンパイル済みのオブジェクトコードをライブラリにする
# 3. メインモジュールをライブラリと一緒にコンパイル
# 4. メイン + ライブラリで実行ファイルにする
#

.PHONY: build

build:
	ocamlc -c libexample/example1.ml -o _build/example1
	ocamlc -c libexample/example2.ml -o _build/example2
	ocamlc -a -o _build/libexample.cma _build/example1.cmo _build/example2.cmo
	ocamlc -c -I _build -o _build/main src/main.ml
	ocamlc -o _build/main.byte _build/libexample.cma _build/main.cmo

clean:
	rm _build/main.byte _build/*.cmo _build/*.cmi _build/*.cma
