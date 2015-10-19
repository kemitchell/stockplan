%.commonform: %.commonform.mustache %.blanks.json
	mustache $*.blanks.json $*.commonform.mustache > $@

%.signatures.json: %.signatures.json.mustache %.blanks.json
	mustache $*.blanks.json $*.signatures.json.mustache > $@

%.docx: %.commonform %.options %.blanks.json
	commonform render \
		--format docx \
		--blanks $*.blanks.json \
		$(shell mustache $*.blanks.json $*.options) \
	< $*.commonform \
	> $@

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
