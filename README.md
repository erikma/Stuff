Random scripts and tools for using across machines.

# Running a MineCraft Server on a Raspberry Pi Over WiFi in a Car
Lots of articles on the web of varying age for how to get an RPi to run a MineCraft server, not much glue scripting and how-to. What we wanted was to be able to have PCs running on battery and a local low-power wifi network in our car so kids in the vehicle could all play, at least until the PC batteries run out, while maintaining the world state during multi-day trips.

Obviously any game server that is capable of running on a Pi can benefit here.

## Parts
* Raspberry Pi 3 (see Compatibility and Performance section below for why not something earlier). Power requirement of about 2 amps when running hot might be too much for your car USB power ports so check your specs.
* TP-Link TL-MR3020. Low power and can run on USB power driven by the car.
* 2 USB power cords for running the Pi and the wifi adapter in the car. Hopefully your vehicle has enough USB power ports in the same spot so you can run both of these at once.
* Short ethernet cable for joining the WAN port on the TP-Link to the ethernet port on the Pi. Why? The less load on the wifi network and over-the-air bandwidth the better your latency will be. (If you've having a game party remember to join the machines over a wired ethernet network where possible to get far lower lag. Unless you live in the middle of nowhere where there are few wifi networks competing with each other in the same air. And even then you're better off. Wifi is great but sort of fragile and latency/lag varies a lot. RIP Charles Thacker.)

## Compatibility and Performance
Tried MineCraft official server 1.12 on an RPi 2, did not make the grade, tons of lag.

Tried Spigot's server and it performed better, far fewer hiccups, but still some lag from clients running on a local wifi network with direct Ethernet jacked between the wifi endpoint and the RPi (see below).
 
Upgrade to an RPi 3: Very obviously faster in all respects. No overclocking with raspi-config but things are fine with the Cortex A8 ARM core and 1200 MHz clock. No particular lag with the Spigot server even with regular view distance, villager spawning, and other default options turned on. Winner!

Note: Only PC/Mac versions of MineCraft, running at the current version of the server you can see in the runminecraft.sh file in this repo, can connect. IPad/Android MineCraft PE editions cannot connect, even if you point it at the PC server default port. Perhaps the "Better Together" MineCraft version for IPad coming out summer of 2017 could possibly interoperate.

## Setting Up a WiFi Adapter for Disconnected Car Use
Let's start with the wifi adapter, our TP-Link.

1. Set the hardware switch to 3G/4G. We found that setting the hardware switch to anything else would just cause problems.
1. Connect the TP-Link to your network using the wired network. If need be you can just direct connect the TP-Link to a machine without a switch.
1. Open a browser and go to the adapter's settings page: http://192.168.0.254 (also listed on your TP-Link's sticker)
1. Log in with the default credentials (also listed on your TP-Link's sticker): username admin, password admin.
1. You can leave the TP-Link in 3G/4G mode. We'll be leaving the 3G/4G USB port unconnected, which defaults to letting us use the WAN ethernet port as a regular network port. You could in fact connect such a cell data adapter if you have one and get it working; we're not that fancy.
1. Set the network name to something unique-sounding. We'll use "THECAR" here but if everyone were to use that name there would be a lot of confusion. Include a fragment of your name or something else recognizable.
1. Set up WPA2-PSK network security and set up a moderately strong password. Write down the password on a piece of paper, as well as on a Post-It note that you'll attach to the TP-Link.
1. Change the admin password on the TP-Link to something secure (but NOT "admin" or anything like it) and write it down on the paper and the Post-It you created in the previous step.
1. Put the paper away in a safe place and attach the Post-It to the TP-Link. (If someone gets hold of the TP-Link, it can be factory-reset anyway, and you may need the passwords when you're on the road.)
1. Reboot the TP-Link if you have not already. Verify the new admin password works for logging in.
1. Make sure your devices can see your new wifi network (your better name than "THECAR"), and join it with the password you set up.

## Setting Up a Raspberry Pi for a Disconnected Car Network
Lots of steps here so we'll break it into sections. You'll need to do all this at home with your own wifi network available.

### Booting the Raspberry Pi and Modifying Settings
In this section we'll do the various manual steps needed to prepare the Pi machine's global settings to reduce power and CPU usage and get ready for installing the MineCraft server.

1. Prepare a copy of Raspbian on an 8GB or larger Micro SD card. You can start here: https://www.raspberrypi.org/downloads/raspbian/
1. Attach an HDMI monitor, keyboard, and mouse to your Pi, plug in the Raspbian Micro SD card, then apply USB power.
1. Let Raspbian do all its first-boot steps and get you into the graphical user interface.
1. Join your home (not the TP-Link) wireless network.
1. Open the Configuration application (Raspberry menu -> Preferences -> Raspberry Pi Configuration) (or use `sudo raspi-config` from a console command line).
1. Choose Update and let it update to latest and restart itself.
1. Change the default password to something different and secure. Write it down on the piece of paper and the Post-It you created previously.
1. Set the host name to something recognizable like 'PiGameServer'
1. Change the System tab -> Boot to "To CLI"(command-line interface)
1. Change the System tab -> Network at Boot to Wait
1. Change the System tab -> Splash Screen to Disabled
1. Change Performance -> GPU Memory '16' (MB) to allow more memory for the game server software and less for running the text console.
1. If need be, change your localization settings for keyboard and operating system locale. (The default English-UK keyboard works until you need to type symbols and they come out all weird...)
1. Reboot the Pi. It should come back up to a text console instead of the graphical window interface.
1. Upgrade your system to the latest packages and kernel using `sudo apt-get upgrade` then `sudo apt-get update`
1. Reboot using the `reboot` command.

### Pulling A Copy Of This Repo
Git is built into Raspbian as a default package so we can usually just use it.

1. After rebooting, the console should show a prompt like `pi@PiGameServer:~ $" which tells us we're in the user directory ("~") of the current user pi on PiGameServer.
1. Run `git clone https://github.com/erikma/Stuff` to clone this repo to your Pi user directory under the 'Stuff' directory/folder.
1. Change to the Stuff directory using the `cd ./Stuff` command.
1. Make our two main scripts runnable on your system using the following commands:
```
chmod +x upgradeMinecraft.sh
chmod +x runminecraft.sh
```

### Compile and Install the Spigot Server
We found the Spigot server to be better than the default MineCraft server (see the compatibility and performance section). You can check it out and see the current release version at https://spigotmc.org/wiki/buildtools

1. Run this command to download and compile the Spigot server: `sudo ./upgradeMinecraft.sh`
1. This can take quite awhile (20+ minutes) as it downloads, compiles, and runs tests against the Spigot server installation.
1. Since we'll be running in a disconnected mode without internet, change the `online-mode=true` setting in the MineCraft service configuration to `online-mode=false` using `nano MineCraft/server.properties` (save with Ctrl+O and Enter, then exit with Ctrl+X).
1. Try running the server with `./runminecraft.sh`
1. It should error out that you need to accept the EULA to continue. To do this, edit eula.txt using the command `nano eula.txt` and change the `eula=false` line to `eula=TRUE` then save with Ctrl+O and Enter, then exit with Ctrl+X
1. Run `./runminecraft.sh` again. It should start up and create the initial world state.
1. Ctrl+C to break out of the server.

### Setting Up the Wired Network to the TP-Link
Be careful here! You're about to change the default network settings on your Raspberry Pi. This will take it off of your home network and make it want to talk directly to the TP-Link over a direct-connect ethernet cable. There are instructions below for how to change things back to get back on your home network temporarily, for example when you want to download a newer MineCraft server version.

1. From the console run the command: `sudo nano /etc/network/interfaces`
1. This opens a text editor called Nano and is looking at the configuration for what physical networks your Pi wants to connect to.
1. Comment out this line (add the # comment in front of it):
```
#iface eth0 inet manual
```
1. Add the following lines to the configuration, but change THECAR to the name of your wifi network:
```
# THECAR wifi adapter ethernet connection configuration
# The DHCP range on the TP-Link is 192.168.0.100-199, our static IP lies outside that.
# THECAR TP-Link wifi adapter claims static IP 192.168.0.254 as its management and gateway interface
auto eth0
allow-hotplug eth0
iface eth0 inet static
    address 192.168.0.50
    netmask 255.255.255.0
    gateway 192.168.0.254
    dns-nameservers 192.168.0.254

# Uncomment this iface line, and comment the 'iface eth0' block above,
# if connecting ethernet to something besides THECAR TP-Link.
# iface eth0 inet dhcp
```
1. Be sure there are no lines like `iface eth0 inet dhcp` anywhere else but in the text  block you added above.
1. Save the file using the Ctrl+O (capital O as in Opera) key and then press Enter.
1. Exit Nano using the Ctrl+X key

### Test your Server
Time to test the server. Let's power off the TP-Link and the Pi to simulate when you first turn them on in the car.

1. Connect the TP-Link to the Raspberry Pi using a short ethernet cable.
1. Power on TP-Link and Raspberry Pi
1. Wait for the Pi to boot into the console, then run `./Stuff/runminecraft.sh`
1. After about a minute the MineCraft server should become available on the wifi network.
1. Connect a PC containing the same MineCraft version as the server to the TP-Link network (THECAR or similar).
1. In MineCraft connect to the server at 192.168.0.50. You should be able to enter the world.

### Set the MineCraft Server to Run On Boot
No screen when running the RPi in your car, time to set up the MineCraft server to run automatically. If you followed Raspberry Pi defaults, the 'pi' user automatically logs onto the machine. So we need to run the runminecraft.sh when the pi user logs on.

We do this by adding a command to the hidden .profile file in the 'pi' user.

1. Change to the pi user home directory: `cd ~`
1. Edit the .profile file: `nano .profile`
1. Add these lines at the bottom:
```
# Run the MineCraft server on startup
cd ~/Stuff
./runminecraft.sh
```
1. Save and exit with Ctrl+O and Enter, then Ctrl+X

### Reconnecting Your Pi To Your Home Network for Upgrades or Debugging
You might find yourself needing to contact the Internet again after making the network changes above. Here's how to restore it temporarily. To get ready for TP-Link again, reverse these changes or make your /etc/network/interfaces look like the previous section.

1. From the console run the command: `sudo nano /etc/network/interfaces`
1. The # character is a comment. You're going to remove this from one place and add it in a few others to change the settings that your Pi uses.
1. Uncomment the `iface eth0 inet dhcp` line by removing the # and the space. It should look like:
```
iface eth0 inet dhcp
```
1. Add a # comment character to these lines so they look like this:
```
#iface eth0 inet static
#    address 192.168.0.50
#    netmask 255.255.255.0
#    gateway 192.168.0.254
#    dns-nameservers 192.168.0.254
```
1. Save the file using the Ctrl+O (capital O as in Opera) key and then press Enter.
1. Exit Nano using the Ctrl+X key
1. Unplug the network cable between the RPi and the TP-Link
1. Reboot using the `reboot` command
