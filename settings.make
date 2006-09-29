prefix =	/usr/local
share =		$(prefix)/share
bindir =	$(prefix)/bin
mandir =	$(share)/man
man1dir =	$(mandir)/man1
pkgname =	autopkgtest
docdir =	$(share)/doc/$(pkgname)
sharedir = 	$(share)/$(pkgname)
etcdir =	/etc
etcinitddir =	$(etcdir)/init.d
xenscripts =	$(etcdir)/xen/scripts
cfg_suffix =	.dist

INSTALL =		install
INSTALL_DIRS =		$(INSTALL) -d
INSTALL_PROGRAM =	$(INSTALL) -m 0755
INSTALL_DATA =		$(INSTALL)
INSTALL_DOC =		$(INSTALL)
