```
# get bbb image (http://elinux.org/Beagleboard:BeagleBoneBlack_Debian)
wget https://rcn-ee.com/rootfs/bb.org/release/2015-11-03/console/BBB-eMMC-flasher-debian-7.9-console-armhf-2015-11-03-2gb.img.xz
sha256sum BBB-eMMC-flasher-debian-7.9-console-armhf-2015-11-03-2gb.img.xz 
  ebdd2938253e179a36a1b9b1f1def2a04595f9e0ee94776988c490ea317e97bc BBB-eMMC-flasher-debian-7.9-console-armhf-2015-11-03-2gb.img.xz

# flash image to sd card
unxz -c BBB-eMMC-flasher-debian-7.9-console-armhf-2015-11-03-2gb.img.xz | sudo dd bs=1M of=/dev/sdb

# edit sd card /etc/network/interfaces
iface eth0 inet static
  address 192.168.7.2
  netmask 255.255.255.252
  network 192.168.7.0
  gateway 192.168.7.1

# flash sd card to bbb

# setup host to masquerade for bbb (eth1 is bbb to host, wlan0 is host to internet)
sudo -i
ifconfig eth1 up 192.168.7.1 netmask 255.255.255.252
iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
iptables --append FORWARD --in-interface eth1
iptables --append FORWARD --in-interface eth1 -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward

# connect to bbb
ssh debian@192.168.7.2
sudo -i
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
route add default gw 192.168.7.1

# upgrade to jessie
sed -i 's/wheezy/jessie/g' /etc/apt/sources.list

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

# nodejs
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash
nvm install iojs
nvm use iojs
nvm alias default iojs

# ledscape
git clone https://github.com/Yona-Appletree/LEDscape
cd LEDscape
cp /boot/dtbs/3.8.13-bone70/am335x-boneblack.dtb{,.preledscape_bk}
cp am335x-boneblack.dtb /boot/dtbs/3.8.13-bone70/
modprobe uio_pruss
sudo sed -i 's/^#cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN$/cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN'/g /boot/uEnv.txt
reboot

ssh debian@192.168.7.2
sudo -i
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
route add default gw 192.168.7.1

cd LEDSCAPE
make
./install-service.sh
```
