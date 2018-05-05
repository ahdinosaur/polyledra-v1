```
# get pocketbeagle image
# - http://beagleboard.org/latest-images
# - http://elinux.org/Beagleboard:BeagleBoneBlack_Debian
wget http://debian.beagleboard.org/images/bone-debian-9.3-iot-armhf-2018-03-05-4gb.img.xz
sha256sum bone-debian-9.3-iot-armhf-2018-03-05-4gb.img.xz
  33fc557f32005c811bd449a59264da6b4a9b4ea9f87a1ee0aa43ae651c7f33d1  /home/dinosaur/Downloads/bone-debian-9.3-iot-armhf-2018-03-05-4gb.img.xz

# flash image to sd card
unxz -c bone-debian-9.3-iot-armhf-2018-03-05-4gb.img.xz | sudo dd bs=1M of=/dev/sdb

# IGNORE
# edit sd card /etc/network/interfaces
# iface usb0 inet static
#  address 192.168.7.2
#  netmask 255.255.255.252
#  network 192.168.7.0
#  gateway 192.168.7.1
# /IGNORE

# flash sd card to bbb

# setup host to masquerade for bbb
# (enx985dad35b556 is bbb to host, wlp4s0 is host to internet)
sudo -i
sysctl net.ipv4.ip_forward=1
# ifconfig enx985dad35b556 up 192.168.7.1
iptables --table nat --append POSTROUTING --out-interface wlp4s0 -j MASQUERADE
iptables --append FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables --append FORWARD --in-interface enx985dad35b556 --out-interface wlp4s0 -j ACCEPT

# connect to bbb
ssh debian@192.168.6.2 # default password is temppwd
sudo -i
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
route add default gw 192.168.7.1

# update
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git vim curl make gcc ntp ntpdate

# set time
mv /etc/localtime /etc/localtime.old
ln -s /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
pkill ntpd
ntpdate pool.ntp.org
systemctl start ntp.service

exit

# rust
curl https://sh.rustup.rs -sSf | sh

# install chandeledra controller app
git clone git://github.com/ahdinosaur/chandeledra
cd chandeledra/controller-app
# TODO ./install

# enable interfaces
# TODO sudo sed -i 's/^#cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN$/cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN'/g /boot/uEnv.txt
# TODO reboot
```
