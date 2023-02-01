# install

## get PocketBeagle image

[get stretch console image](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Stretch_Snapshot_console)

```shell
# download
wget https://rcn-ee.com/rootfs/bb.org/testing/2018-12-10/stretch-console/bone-debian-9.6-console-armhf-2018-12-10-1gb.img.xz

# verify hash
sha256sum bone-debian-9.6-console-armhf-2018-12-10-1gb.img.xz 
# ce975a7e71c80ddab8bf486c79b1bdd2b0dcac2b433a316c5308ddcdf9533dee  bone-debian-9.6-console-armhf-2018-12-10-1gb.img.xz

# write to sd card
xzcat bone-debian-9.6-console-armhf-2018-12-10-1gb.img.xz | sudo dd of=/dev/sdX
```

## setup PocketBeagle

```shell
# send ssh key
ssh-copy-id debian@192.168.6.2
# default password is temppwd
```

connect

```shell
ssh debian@192.168.7.2
```

and run

```shell
# https://serverfault.com/a/841150
sudo loginctl enable-linger debian
```

---

create environment file

```
nano ~/polyledra/polyledra.env
```

```
PIXEL_DENSITY=30
EDGE_LENGTH=1
NUM_ARMS=3
FPS=60

DEVICE=pocketbeagle

MODE_PIN_1=59
MODE_PIN_2=58
MODE_PIN_4=57
MODE_PIN_8=60

BRIGHTNESS_PIN_1=117
BRIGHTNESS_PIN_2=114
BRIGHTNESS_PIN_4=111
BRIGHTNESS_PIN_8=88
```

---

disable usb mass storage file

```
nano /opt/scripts/boot/default/bb-boot
```

uncomment

```
USB_IMAGE_FILE_DISABLED=yes
```

## install chandeledra

```shell
./bin/install-on-bone
```

(if `GLIBC` version error, run `cargo clean`: https://github.com/japaric/cross/issues/39)

## maintenance

to check service

```shell
systemctl --user status chandeledra
```

to enable logs

```shell
sudo nano /etc/systemd/journald.conf 
```

```
[Journal]
Storage=persistent
```

to view logs

```
journalctl --user -u chandeledra
```

---

## notes

static network interface

```
# IGNORE
# edit sd card /etc/network/interfaces
# iface usb0 inet static
#  address 192.168.7.2
#  netmask 255.255.255.252
#  network 192.168.7.0
#  gateway 192.168.7.1
# /IGNORE

```

masquerade internet

```

# setup host to masquerade for bbb
# (enx985dad35b556 is bbb to host, wlp4s0 is host to internet)
sudo -i
sysctl net.ipv4.ip_forward=1
# ifconfig enx985dad35b556 up 192.168.7.1
iptables --table nat --append POSTROUTING --out-interface wlp4s0 -j MASQUERADE
iptables --append FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables --append FORWARD --in-interface enx985dad35b556 --out-interface wlp4s0 -j ACCEPT
```

add upgrade all the things

```
ssh debian@192.168.6.2
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

# rust
# curl https://sh.rustup.rs -sSf | sh

# install chandeledra controller app
# git clone git://github.com/ahdinosaur/chandeledra
# cd chandeledra/controller-app
# TODO ./install

# enable interfaces
# TODO sudo sed -i 's/^#cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN$/cape_disable=capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN'/g /boot/uEnv.txt
# TODO reboot

exit
```

---

notes

- start @ 0
- 0 -> 1
  - 0A -> OB @ 1
  - 0B -> OC @ 0
  - 0C -> 1A @ 1
- 1 -> 2
  - 1A -> 1B @ 2
  - 1B -> 1C @ 1: POWER
  - 1C -> 2A @ 2
- 2 -> 0
  - 2A -> 2B @ 0
  - 2B -> 2C @ 2
  - 2C -> 3A @ 0
- 0 -> 3
  - 3A -> 3B @ 3: POWER
  - 3B -> 3C @ 0
  - 3C -> 4A @ 3
- 3 -> 1
  - 4A -> 4B @ 1
  - 4B -> 4C @ 3: POWER
  - 4C -> 5A @ 1
- 2 -> 3

