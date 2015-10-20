all: restrictedstock/packet.pdf option/packet.pdf

restrictedstock/packet.pdf: restrictedstock/rspa.pdf plan.pdf restrictedstock/stockpower.pdf restrictedstock/acknowledgment.pdf restrictedstock/83b.pdf rule506.pdf restrictedstock/receipt.pdf restrictedstock/consent.pdf
	pdftk $^ cat output $@

option/packet.pdf: option/notice.pdf plan.pdf option/agreement.pdf option/exercise.pdf rule506.pdf
	pdftk $^ cat output $@

%.commonform: %.commonform.mustache %.blanks.json
	mustache $*.blanks.json $*.commonform.mustache > $@

%.signatures.json: %.signatures.json.mustache %.blanks.json
	mustache $*.blanks.json $*.signatures.json.mustache > $@

%.docx: %.commonform %.signatures.json %.options %.blanks.json
	commonform render \
		--format docx \
		--signatures $*.signatures.json \
		--blanks $*.blanks.json \
		$(shell mustache $*.blanks.json $*.options) \
	< $*.commonform \
	> $@

plan.docx: plan.commonform plan.options plan.blanks.json
	commonform render \
		--format docx \
		--blanks plan.blanks.json \
		$(shell mustache plan.blanks.json plan.options) \
	< plan.commonform \
	> $@

option/agreement.docx: option/agreement.commonform option/agreement.options option/agreement.blanks.json
	commonform render \
		--format docx \
		--blanks option/agreement.blanks.json \
		$(shell mustache option/agreement.blanks.json option/agreement.options) \
	< option/agreement.commonform \
	> $@

%.pdf: %.docx
	doc2pdf $<

.PHONY: clean

clean:
	rm -rf *.docx *.pdf restrictedstock/*.docx restrictedstock/*.pdf
