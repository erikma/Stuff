# Quick script to put together all the calls needed to update a Raspberry Pi's
# tools, package manager, packages, and OS (which interestingly is a package
# in Linux Debian).
#
# Set this script file to be executable using "chmod +x updateSystem.sh"
# Run this script with sudo, like "sudo ./updateSystem.sh"

echo
echo Upgrading all packages on system
echo
apt-get update
apt-get upgrade
