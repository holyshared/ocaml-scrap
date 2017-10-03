.PHONY: build clean lib

LIBNAME=libexample
OCB_FLAGS = -use-ocamlfind -I src -I $(LIBNAME)
OCB = ocamlbuild $(OCB_FLAGS)

# cma  - bytecode
# cmxa - nativecode
# cmxs - dynlink library
build:
	$(OCB) $(LIBNAME).cma
	$(OCB) $(LIBNAME).cmxa
	$(OCB) $(LIBNAME).cmxs
	$(OCB) -pkg dynlink main.native

clean:
	$(OCB) -clean
