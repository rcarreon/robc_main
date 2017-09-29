bin_SCRIPTS = rnetapp nfstop
man1_MANS = rnetapp.1 nfstop.1
CLEANFILES = $(man1_MANS) $(bin_SCRIPTS)
EXTRA_DIST=rnetapp.spec rnetapp.spec.in rnetapp.in rnetapp.pod nfstop.in nfstop.pod

do_subst = sed -e 's,[@]PERL[@],$(PERL),g' \
               -e 's,[@]VERSION[@],$(VERSION),g' \
               -e 's,[@]BINDIR[@],$(bindir),g' 


.SECONDEXPANSION:

default: $(bin_SCRIPTS) $(man1_MANS)

$(bin_SCRIPTS): $$@.in Makefile
	$(do_subst) < $(srcdir)/$@.in > $@
	chmod +x $@

%.1: %.pod
	pod2man $(srcdir)/$*.pod > $*.1
