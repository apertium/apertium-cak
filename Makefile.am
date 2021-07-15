###############################################################################
## Makefile for apertium-cak
###############################################################################

LANG1=cak
BASENAME=apertium-$(LANG1)

TARGETS_COMMON =			\
	$(LANG1).automorf.hfst		\
	$(LANG1).automorf.bin		\
	$(LANG1).automorf.att.gz	\
	$(LANG1).autogen.hfst		\
	$(LANG1).autogen.bin		\
	$(LANG1).autogen.att.gz		\
	$(LANG1).autoseg.hfst		\
	$(LANG1).autoseg.bin		\
	$(LANG1).rlx.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################

cak.automorf.hfst: cak.mor.hfst 
	hfst-fst2fst -w $< -o $@

cak.autogen.hfst: cak.gen.hfst
	hfst-fst2fst -w $< -o $@

cak.autoseg.hfst: cak.seg.hfst 
	hfst-fst2fst -w $< -o $@

cak.mor.hfst: cak.gen.hfst cak.mor.twol.hfst cak.spellrelax.hfst
	hfst-compose-intersect -1 cak.gen.hfst -2 cak.mor.twol.hfst | hfst-compose -F -1 - -2 cak.spellrelax.hfst | hfst-invert -o $@

# <impf><o_pl1><s_pl3>tʼis<v><tv>+o<mark>:k>oj>ki>tʼis>o
cak.gen.hfst: cak.lexc.hfst cak.twol.hfst
	hfst-compose-intersect -1 cak.lexc.hfst -2 cak.twol.hfst -o $@

cak.twol.hfst: apertium-cak.cak.twol
	hfst-twolc $< -o $@

# <impf><o_pl1><s_pl3>tʼis<v><tv>+o<mark>:k>{o}j>k{i}>tʼis>o
cak.lexc.hfst: apertium-cak.cak.lexc
	hfst-lexc -A --Werror $< -o $@

cak.mor.twol.hfst: apertium-cak.cak.mor.twol
	hfst-twolc apertium-cak.cak.mor.twol -o cak.mor.twol.hfst

# kojkitʼiso:k>oj>ki>tʼis>o
cak.seg.hfst: cak.mor.hfst cak.gen.hfst
	hfst-compose -F -1 cak.mor.hfst -2 cak.gen.hfst -o cak.seg.hfst 

cak.spellrelax.hfst: apertium-cak.cak.spellrelax 
	hfst-regexp2fst -S -o $@ < $<

cak.rlx.bin: apertium-cak.cak.rlx
	cg-comp $< $@

$(LANG1).autogen.att.gz: $(LANG1).gen.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).automorf.att.gz: $(LANG1).mor.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).autoseg.att.gz: $(LANG1).seg.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

$(LANG1).autoseg.bin: $(LANG1).autoseg.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autoseg.att
	lt-comp lr .deps/$(LANG1).autoseg.att $@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).lexc		\
		$(BASENAME).$(LANG1).twol	\
		$(BASENAME).$(LANG1).spellrelax \
		$(BASENAME).$(LANG1).rlx	\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_cak_dir: This is where the compiled binaries go
#   apertium_cak_srcdir: This is where the source files go

apertium_cakdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_cak_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_cak_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) 

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	$(INSTALL_DATA) $(BASENAME).$(LANG1).lexc $(DESTDIR)$(apertium_cak_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).twol $(DESTDIR)$(apertium_cak_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_cak_srcdir)


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################

test: all
	apertium-regtest test
