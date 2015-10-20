all: stock/packet.pdf option/packet.pdf plan.pdf

stock/packet.pdf: stock/rspa.pdf plan.pdf stock/stockpower.pdf stock/acknowledgment.pdf stock/83b.pdf rule506.pdf stock/receipt.pdf stock/consent.pdf
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

%.docx: %.commonform %.nosignatures %.options %.blanks.json
	commonform render \
		--format docx \
		--blanks $*.blanks.json \
		$(shell mustache $*.blanks.json $*.options) \
	< $*.commonform \
	> $@

%.pdf: %.docx
	doc2pdf $<

.PHONY: clean

clean:
	rm -rf *.docx *.pdf stock/*.docx stock/*.pdf option/*.docx option/*.pdf
