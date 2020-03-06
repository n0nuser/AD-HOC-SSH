# Portable HostAPd

## INTRODUCTION 📃

This lets you create a WiFi Hotspot for your linux system without internet connection to access by just connecting to its WiFi AP.<br> You can get internet by bridging your adapter to another with internet.<br>
(I have part of the code needed for this in my RogueAP repository) :neckbeard:

## BACKGROUND 👻

I wanted to easily carry my Raspberry Pi anywhere without the burden of having to carry a screen or a keyboard.

So I searched for a way to connect my phone to it via SSH but without being connected to a WLAN, because that means I would have to stick to places where I have the Password or an ethernet connection.

The final way was HostAPd, a program that let's you do exactly this.

The installation of everything is a bit tedious so I just automatized it.

## INSTALLATION

I made the project thinking on Raspbian because it's easier to set up (Raspi-Config) and because you can get every tool you need by just adding repositories (like the Katoolin to get Kali tools). Tested on Raspbian Buster (February 2020).

- :exclamation: It's very recommended to install SSH (VNC,...) before running the setup script as It will let you control it when AP is installed.

- You need to install: _ifconfig_, _awk_, _grep_, _systemctl_ and _iptables_.

- The installation is as simple as:
```
git clone https://github.com/n0nuser/Portable-HostAPd.git
cd Portable-HostAPd
chmod +x setup.sh
```

## USAGE 📱

:exclamation: The Internet adapter you use will only have this purpose, which means that:
- If you setup the AP you will be able to connect to it but only control it with SSH
- This will leave you without internet access (unless you bridge it with other that has)
- If you then connect to a WiFi, but are connected to the system via the AP, you'll lose connection.

Just run:

```bash
sudo ./setup.sh SSID PASSWORD
```

And there you go!

## USES 🚙

The best case that gets to my mind is wardriving or just collecting data from the environment.

If you have other uses in mind, please post an Issue or contact me so I update the readme!
