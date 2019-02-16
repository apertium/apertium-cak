all: cak.gen.hfst cak.mor.hfst cak.mor.hfstol

cak.lexc.hfst: apertium-cak.cak.lexc
	hfst-lexc $< -o $@

cak.twol.hfst: apertium-cak.cak.twol
	hfst-twolc $< -o $@

cak.gen.hfst: cak.twol.hfst cak.lexc.hfst
	hfst-compose-intersect -1 cak.lexc.hfst -2 cak.twol.hfst -o $@

cak.mor.hfst: cak.gen.hfst
	hfst-invert $< -o $@

cak.mor.hfstol: cak.mor.hfst
	hfst-fst2fst -w $< -o $@	

clean:
	rm *.hfst *.hfstol
