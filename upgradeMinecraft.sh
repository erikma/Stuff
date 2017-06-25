#!/bin/bash

# Assumes you are Internet-connected, which might require temporarily disabling
# the static IP address to the wifi adapter using 'sudo nano /etc/network/interfaces' and commenting out
# the static server configuration for eth0, and enabling automatic DHCP instead.

cd ~/Stuff
if [ ! -d ./MineCraft ]; then
    mkdir ./MineCraft
fi
cd ./MineCraft

if [ -f ./BuildTools.jar ]; then
    rm ./BuildTools.jar
fi

# 'Spigot' optimized MineCraft server - https://spigotmc.org/wiki/buildtools
SPIGOT_VERSION=1.12
echo
echo Downloading latest Spigot server buildtools and building $SPIGOT_VERSION
echo
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -jar BuildTools.jar --rev $SPIGOT_VERSION
