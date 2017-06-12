#!/bin/bash

# Run this script with sudo, e.g. 'sudo upgradeMinecraft.sh"
#
# Assumes you are Internet-connected, which might  require temporarily disabling
# the offline static IP address using 'sudo nano /etc/network/interfaces' and commenting out
# the static server configuration for eth0, and enabling automatic DHCP instead.

cd ./MineCraft

# Update system
echo
echo Upgrading all packages on system
echo
apt-get update

if [-f BuildTools.jar]; then
    rm BuildTools.jar
fi

# 'Spigot' optimized MineCraft server - https://spigotmc.org/wiki/buildtools
echo
echo Downloading latest Spigot server buildtools and building 1.12
echo
wget https:// hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -jar BuildTools.jar --rev 1.12
