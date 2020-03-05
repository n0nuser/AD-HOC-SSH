# Portable HostAPd

## INTRODUCTION 📃

It needs _hostapd_, _dnsmasq_, _systemctl_ and _iptables_.

This lets you create a WiFi Hotspot for your linux system without internet connection to access by just connecting to its WiFi AP.<br> You can get internet by bridging your adapter to another with internet.<br>
(I have part of the code needed for this in my RogueAP repository) :neckbeard:

## BACKGROUND 👻

I wanted to easily carry my Raspberry Pi anywhere without the burden of having to carry a screen or a keyboard.

So I searched for a way to connect my phone to it via SSH but without being connected to a WLAN, because that means I would have to stick to places where I have the Password or an ethernet connection.

The final way was HostAPd, a program that let's you do exactly this.

The installation of everything is a bit tedious so I just automatized it.


## USAGE 📱

:exclamation: It's very recommended to install SSH (VNC,...) before running the setup script as It will let you control it when AP is installed.

:exclamation: The Internet adapter you use will only have this purpose, which means that:
- If you setup the AP you will be able to connect to it but only control it with SSH
- This will leave you without internet access (unless you bridge it with other that has)
- If you then connect to a WiFi, but are connected to the system via the AP, you'll lose connection.

Explained that, give it execution permissions (`chmod +x setup.sh`) and run it:

```bash
sudo ./setup.sh SSID PASSWORD
```

There you go!
