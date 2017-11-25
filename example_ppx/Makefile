build:
	jbuilder build

test:
	jbuilder runtest

clean:
	rm -rf _build

ppx:
	ocamlc -dsource -ppx ./_build/install/default/bin/ppx_getenv foo.ml
	ocamlc -dsource -ppx ./_build/install/default/bin/ppx_record_feilds bar.ml

.PHONY: default test clean ppx

