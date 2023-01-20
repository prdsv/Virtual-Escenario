apt-get update
apt-get install arpwatch

cd etc/apt
echo 'deb http://archive.ubuntu.com/ubuntu/ trusty main universe restricted multiverse/' >> sources.list

apt-get update

apt-get -f install sysv-rc-conf


cd /etc/default/

sed -i 's/INTERFACES=""/INTERFACES="net1 brint"/g' arpwatch

sysv-rc-conf --level 35 arpwatch on

/etc/init.d/arpwatch start

ping -c 5 10.100.1.254

ping -c 5 10.100.3.1

/etc/init.d/arpwatch stop

cd /var/lib/arpwatch
