all: cak.hfst 

cak.lexc.hfst: apertium-cak.cak.lexc
	hfst-lexc $< -o $@

cak.twol.hfst: apertium-cak.cak.twol
	hfst-twolc $< -o $@

cak.hfst: cak.twol.hfst cak.lexc.hfst
	hfst-compose-intersect -1 cak.lexc.hfst -2 cak.twol.hfst -o $@

clean:
	rm *.hfst
