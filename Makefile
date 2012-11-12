BFLAGS = -cflags -g,-annot -lflags -g -yaccflag -v
# BFLAGS += -use-menhir
# BFLAGS += -verbose 0
SRCFILES = basic.ml typesystem.ml substitute.ml printer.ml simpletyping.ml scheme.ml grammar.mly tokens.mll toplevel.ml checker.ml 
all: TAGS run
checker.byte checker.native: $(SRCFILES); ocamlbuild $(BFLAGS) $@
clean::; ocamlbuild -clean
TAGS: $(SRCFILES); ( scripts/etags.ocaml $(SRCFILES) && etags test.ts -o - ) >$@
clean::; rm -f TAGS
run: checker.byte; OCAMLRUNPARAM=b ./$< <test.ts
run.native: checker.native; OCAMLRUNPARAM=b ./$< <test.ts
