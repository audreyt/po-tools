

demo ::
	@-rm -rf demo
	cp -Rf eg demo
	@echo "### Step 1: Turn .po file into new and reference .txt files"
	runghc po2txt.hs demo/zh_CN.po
	@echo ""
	@echo "### Step 2: Send zh_CN.po.new.txt to myGengo Translate API..."
	@echo "###        (with zh_CN.po.ref.txt included in comment as reference)"
	@echo ""
	@echo "### Step 3: Received RequestTracker-zh_CN.txt from myGengo;"
	@echo "###         convert it back to .po format"
	runghc txt2po.hs demo/RequestTracker-zh_CN.txt
	@echo ""
	@echo "### Step 4: Run msgmerge to merge new translations with old ones"
	msgmerge -N --previous -s --no-wrap demo/RequestTracker-zh_CN.txt.po demo/zh_CN.po > demo/merged-zh_CN.po
	@echo ""
	@echo "### All Done! See demo/merged-zh_CN.po for the final output."

bin/%: %.hs
	ghc -o $@ $<

bin: bin/po2txt bin/txt2po

clean:
	rm -rfv bin/* *.hi *.o

.PHONY: bin
