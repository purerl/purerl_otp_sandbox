.PHONY: all ps ide clean erl

PS_SRC = ps_src
COMPILED_PS = src/compiled_ps
OUTPUT = output

all: ps erl

ide:
	psc-package sources | xargs purs compile '$(PS_SRC)/**/*.purs' --json-errors

ps:
	psc-package sources | xargs purs compile '$(PS_SRC)/**/*.purs'

# Useful to update externs if sources won't compile
ps-deps:
	psc-package sources | xargs purs compile

clean:
	rm -rf $(OUTPUT)/*
	rm -f $(COMPILED_PS)/*

erl:
	mkdir -p $(COMPILED_PS)
	cp -p $(OUTPUT)/*/*.erl $(COMPILED_PS)/
