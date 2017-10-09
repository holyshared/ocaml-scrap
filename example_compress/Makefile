.PHONY: build clean

OCB_LIB_FLAGS = -use-ocamlfind -I compress
OCB_BIN_FLAGS = -use-ocamlfind -I bin

OCB = ocamlbuild

build:
	$(OCB) $(OCB_LIB_FLAGS) compress.cmxa
	$(OCB) $(OCB_BIN_FLAGS) -I compress -lib compress main.native

clean:
	$(OCB) -clean
