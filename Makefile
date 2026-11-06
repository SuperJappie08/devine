#!/usr/bin/env make
# Installer Makefile for the devine script
#
# NOTE: This Makefile is very basic and probably missing some features
#       It is probably also not adhering to all conventions.
#
# Author: Jasper van Brakel
# Date: 6 November 2026
# License: Apache-2.0

Program = devine

#### Start of system configuration section. ####

MAKEFILE := $(realpath $(lastword $(MAKEFILE_LIST)))
srcdir := $(shell dirname $(MAKEFILE))

prefix = ~/.local

# Executable directories
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin

#### End of system configuration section. ####

.PHONY: help ## Prints this help message
help:
	@echo "Usage:\n  make [VAR=VALUE] <target>\n"
	@echo "Install $(Program) from $(srcdir)"
	@echo
	@echo "Makefile Targets:"
	@awk '/^\.PHONY: [a-zA-Z_-]+ ## .*$$/ { printf "    %-19s %s\n", $$2, substr($$0, index($$0, "##")+3) }' $(MAKEFILE)


.PHONY: configurations ## A list of the user-configurable install settings
configurations:
	@echo "Configurations:"
	@echo "    srcdir = $(srcdir)"
	@echo "        Folder containing sources"
	@echo "    prefix = $(prefix) [~/.local]"
	@echo "        Root of install directory"
	@echo "    exec_prefix = $(exec_prefix) [{prefix}]"
	@echo "        Root of executable install directory"
	@echo "    bindir = $(bindir) [{exec_prefix}/bin]"
	@echo "        Install location of the Binary"

.PHONY: installdirs ## Create install directories
installdirs: $(bindir)

$(bindir):
	@echo "Creating '$@'"
	@mkdir -p $@

.PHONY: copy-install ## Install the program by copying the files
copy-install: installdirs
	@echo "Installing [COPY]"
	install -T $(srcdir)/devine $(bindir)/$(Program)

.PHONY: hardlink-install ## Install the program by hardlinking the files
hardlink-install: installdirs
	@echo "Installing [HARDLINK]"
	ln -T $(srcdir)/devine $(bindir)/$(Program)

.PHONY: symlink-install ## Install the program by symlinking the files
symlink-install: installdirs
	@echo "Installing [SYMLINK]"
	ln --symbolic -T $(srcdir)/devine $(bindir)/$(Program)

.PHONY: uninstall ## Uninstall the program
uninstall:
	@echo "Uninstalling"
	-rm $(bindir)/$(Program)
