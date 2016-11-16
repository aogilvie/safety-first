##
# SafetyFirst Makefile
#
##

# Set default shell
SHELL = /bin/bash

# Function for help
define helpText

make backup                          Create a backup
make list                            List current backups
make delete                          Delete a backup
make restore                         Restore a backup
make package                         Create RPM package

endef
export helpText

.PHONY: backup list delete restore

# Default make target
%::
	@echo "$$helpText"
default:
	@echo "$$helpText"

# Backup target
backup:
	@scripts/backup.sh

# List target
list:
	@scripts/list.sh

# Delete target
delete:
	@scripts/delete.sh

# Restore target
restore:
	@scripts/restore.sh

# Package rpm file
package:
	tar cpf sources.tar lib scripts
	mkdir -p rpm-build
	cp sources.tar rpm-build/
	rpmbuild --define "_topdir %(pwd)/rpm-build" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}" \
	--define "_specdir %{_topdir}" \
	--define '_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm' \
	--define "_sourcedir  %{_topdir}" \
	-ba rpm.spec
