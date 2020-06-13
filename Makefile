
# Testing...
SHELL := /bin/bash

TRANS := NIV2011
REF := $(shell grep -v \^\# references.txt | tail -1)

stats: passage.pdf
	@echo
	pdfinfo $^ | grep -i pages | cat
	@echo

passage.pdf: passage.ps
	ps2pdf $^ $@

# could use smartypants if more stuff required:
passage.ps: passage.html html2ps.css
	cat passage.html | sed "s/--/ \&ndash; /g" | recode -d utf8..html | html2ps -f html2ps.css > $@

passage.html: head.html passage.body foot.html
	cat $^ | sed "s/TITLE/$(REF)/" | ./cleanup > $@

passage.body: passage.dia
	cat $^ | grep -v '($(TRANS))' | grep -v '^: ' > $@

passage.dia: references.txt Makefile
	diatheke -b $(TRANS) -f html -k "$(REF)" > $@

# --- Other stuff

hardcopy: passage.pdf
	lp -dHL1110 $^


