build:
	jbuilder build

test:
	jbuilder runtest

clean:
	rm -rf _build


dump:
	-ocamlc -dparsetree foo.ml 2> foo-out.dump
	-ocamlc -dparsetree bar.ml 2> bar-out.dump

ppx:
	ocamlc -dsource -ppx ./_build/install/default/bin/ppx_getenv foo.ml
	ocamlc -dsource -ppx ./_build/install/default/bin/ppx_record_feilds bar.ml

.PHONY: default test clean ppx dump
