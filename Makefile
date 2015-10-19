%.commonform: %.commonform.mustache %.blanks.json
	mustache $*.blanks.json $*.commonform.mustache > $@

%.docx: %.commonform %.signatures.json %.options %.blanks.json
	commonform render \
		--format docx \
		--signatures $*.signatures.json \
		--blanks $*.blanks.json \
		$(shell mustache $*.blanks.json $*.options) \
	< $*.commonform \
	> $@

%.pdf: %.docx
	doc2pdf $<

.PHONY: clean

clean:
	rm -rf *.docx *.pdf
