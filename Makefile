

REF := $(shell tail -1 references.txt)

passage.pdf: passage.ps
	ps2pdf $^ $@

passage.ps: passage.html html2ps.css
	cat passage.html | html2ps -f html2ps.css > $@

passage.html: head.html passage.body foot.html
	cat $^ | sed "s/TITLE/$(REF)/" | ./cleanup > $@

passage.body: references.txt Makefile
	diatheke -b NIV -f html -k "$(REF)" | grep -v '(NIV)' > $@

# --- Other stuff

hardcopy: passage.pdf
	lp $^


