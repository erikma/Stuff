#!/bin/bash
cd ./MineCraft
# Previously removed: minecraft_server.1.12.jar in favor of faster Spigot server
java -Xmx704M -Xms704M -XX:+UseConcMarkSweepGC -jar spigot-1.12.jar nogui
