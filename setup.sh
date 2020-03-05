#!/bin/bash

if [[ $EUID -ne 0 ]];then
  echo "The setup script must be installed as root."
  echo "USAGE: sudo setup.sh SSID PASSWORD"
  exit
fi

command -v systemctl &> /dev/null
if [ $? -ne 0 ]; then
  echo \"systemctl\" is not installed.
  exit
fi

command -v iptables &> /dev/null
if [ $? -ne 0 ]; then
  echo \"iptables\" is not installed.
  exit
fi

if [ $# -ne 2 ];then
  echo USAGE: sudo setup.sh SSID PASSWORD
  exit
fi

echo -e "GET google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo ""
else
  echo "You're not connected to internet."
  exit
fi

#clear
echo -e "It's recommended that you have installed SSH as server before installing the AP."
read -p "Do you want to continue? (Y/n): " yesOrNo
case $yesOrNo in
  "Y"|"y")
    echo " "
  ;;
  "N"|"n")
    echo "Bye!"
  ;;
  *)
    echo "Not a valid Option"
    exit 1
  ;;
esac

WIFI=$(cat /proc/net/dev | tail -n 1 | awk '{print $1}' | tr -d :)
read -p "Adapter $WIFI will be used, do you want to continue? (Y/n): " yesOrNo
case $yesOrNo in
  "Y"|"y")
    echo " "
    ;;
  "N"|"n")
     read -p "Write the adapter you want to use:" WIFI
     nmcli connection show | awk '{print $4}' | tr "\n" " " | tr -d - | grep $WIFI > /dev/null 2>&1
     if [ $? -ne 0 ]; then
       echo "That adapter does not exists."
       exit 1
     fi
     ;;
  *)
    echo "That's an invalid option."
    exit 1
    ;;
esac

sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y

sudo apt-get install dnsmasq hostapd -y
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# Revisar la interfaz a coger
sudo echo "
hostname
clientid
persistent
option rapid_commit
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
option interface_mtu
require dhcp_server_identifier
slaac private
interface $WIFI
static ip_address=192.168.1.1/24
nohook wpa_supplicant" >> /etc/dhcpcd.conf
sudo systemctl restart dhcpcd

sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
#sudo nano /etc/dnsmasq.conf
#Revisar interfaz
sudo echo "interface=$WIFI
dhcp-range=192.168.1.2,192.168.1.150,255.255.255.0,24h" > /etc/dnsmasq.conf
sudo systemctl start dnsmasq

sudo echo "interface=$WIFI
driver=nl80211
ssid=$1
hw_mode=g
channel=9
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf
sudo echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" > /etc/default/hostapd

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

sudo echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf

sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

iptables-restore < /etc/iptables.ipv4.nat

sudo reboot
