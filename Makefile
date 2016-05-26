# This file is part of autopkgtest
# autopkgtest is a tool for testing Debian binary packages
#
# autopkgtest is Copyright (C) 2006 Canonical Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# See the file CREDITS for a full list of credits information (often
# installed as /usr/share/doc/autopkgtest/CREDITS).

prefix =	/usr
share =		$(DESTDIR)$(prefix)/share
bindir =	$(DESTDIR)$(prefix)/bin
man1dir =	$(share)/man/man1
pkgname =	autopkgtest
docdir =	$(share)/doc/$(pkgname)
datadir =	$(share)/$(pkgname)
pythondir = 	$(datadir)/lib
virtdir = 	$(datadir)/virt

INSTALL =	install
INSTALL_DIRS =	$(INSTALL) -d
INSTALL_PROG =	$(INSTALL) -m 0755
INSTALL_DATA =	$(INSTALL) -m 0644

virts =		virt/chroot \
		virt/lxc \
		virt/lxd \
		virt/null \
		virt/qemu \
		virt/schroot \
		virt/ssh \
		$(NULL)

programs =	tools/adt-buildvm-ubuntu-cloud \
		tools/adt-build-lxc \
		tools/autopkgtest-build-lxd \
		runner/autopkgtest \
		$(NULL)

pythonfiles =	lib/VirtSubproc.py \
		lib/adtlog.py \
		lib/adt_run_args.py \
		lib/autopkgtest_args.py \
		lib/adt_testbed.py \
		lib/adt_binaries.py \
		lib/testdesc.py \
		$(NULL)

rstfiles =	$(wildcard doc/*.rst)
htmlfiles =	$(patsubst %.rst,%.html,$(rstfiles))

%.html: %.rst
	rst2html -v $< > $@

all: $(htmlfiles)

install:
	$(INSTALL_DIRS) $(bindir) $(docdir) $(man1dir) $(pythondir) $(virtdir) $(datadir)/setup-commands $(datadir)/ssh-setup
	set -e; for f in $(programs); do \
		$(INSTALL_PROG) $$f $(bindir); \
		test ! -f $$f.1 || $(INSTALL_DATA) $$f.1 $(man1dir); \
		done
	set -e; for f in $(virts); do \
		$(INSTALL_PROG) $$f $(virtdir); \
		man=$$(dirname $$f)/autopkgtest-$$(basename $$f).1; \
		test ! -f $$man || $(INSTALL_DATA) $$man $(man1dir); \
		done
	$(INSTALL_DATA) $(pythonfiles) $(pythondir)
	$(INSTALL_DATA) CREDITS $(docdir)
	$(INSTALL_DATA) $(rstfiles) $(htmlfiles) $(docdir)
	$(INSTALL_PROG) setup-commands/*[!~] $(datadir)/setup-commands
	$(INSTALL_PROG) ssh-setup/[a-z]*[!~] $(datadir)/ssh-setup
	$(INSTALL_DATA) ssh-setup/SKELETON $(datadir)/ssh-setup
	# legacy CLI
	ln -s autopkgtest $(bindir)/adt-run
	ln -s autopkgtest-build-lxd $(bindir)/adt-build-lxd
	$(INSTALL_DATA) runner/adt-run.1 $(man1dir)

clean:
	rm -f */*.pyc
	rm -f $(htmlfiles)
