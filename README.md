# Portable HostAPd

## INTRODUCTION 💬

This lets you create a WiFi Hotspot for your linux system without internet connection to access by just connecting to its WiFi AP.<br> You can get internet by bridging your adapter to another with internet.<br>
(I have part of the code needed for this in my RogueAP repository) :neckbeard:

## BACKGROUND 👻

I wanted to easily carry my Raspberry Pi anywhere without the hassle of having to carry a screen or a keyboard.

So I searched for a way to connect my phone to it via SSH but without being connected to a WLAN, because that means I would have to stick to places where I have the Password or an ethernet connection.

The final way was HostAPd, a program that let's you do exactly this.

The installation of everything is a bit tedious so I just automatized it.

## INSTALLATION 📃

I made the project thinking on Raspbian because it's easier to set up (Raspi-Config) and because you can get every tool you need by just adding repositories (like the Katoolin to get Kali tools). Tested on Raspbian Buster (v. February 2020).

In case of going for Raspbian, install the buster lite option with console login as it need much less space and runs faster.

What you need:

- If you just recently installed your OS:

  - Configure your locales and keyboard layout 🎹

  - Configure your password and hostname 👤

- Get internet connection (just for installation) 📶

- Enable SSH

- Enable autologin

- Install: _ifconfig_, _awk_, _grep_, _systemctl_ and _iptables_.

The installation is as simple as:
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

And there you go! :rage3:

You're most likely won't use the screen and the keyboard again.

## USES 🚙

The best case that gets to my mind is wardriving or just collecting data from the environment.

If you have other uses in mind, please post an Issue or contact me so I update the readme!

## TROUBLESHOOTING 🔫

If your AP doesn't appear, it might be because:
- Some service didn't fully installed. In this case erase all the redirections to `/dev/null` and watch where it crashes.
- The driver of the WiFi adapter is not the usual Broadcom. In that case, search which driver does your adapter need and change it into: `/etc/hostapd/hostapd.conf`.

If the AP appears but doesn't let you connect to it, it will probably be the DHCP which is not assigning you an IP, so revise that dhcpcd service is using the file created/modified: `/etc/dhcpcd.conf`.
