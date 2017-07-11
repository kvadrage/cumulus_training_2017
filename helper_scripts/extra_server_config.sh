#!/bin/bash

echo "#################################"
echo "  Running Extra_Server_Config.sh"
echo "#################################"
sudo su

useradd -m -s /bin/bash cumulus
echo "cumulus:CumulusLinux!" | chpasswd

## Convenience code. This is normally done in ZTP.
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus
mkdir /home/cumulus/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFitDWrhnlnOTBHw5pR/hIpqNlAJKUhbdFAd/1YeGW86AVxOgiGxdzK4A+G62gn7d1WkcOELpKmnqlp6aAu4xQ+C0dEXBwZ1QDoV+AgJ/y2GKLaaeefzRyKEm+uhJNqeD+fzVceeaEFRkqPwQ4m6L0vdnIs7Udbv57zF5BXKi5YJpIvNcY8Bu8QfkoS+qypYBAtxGsElx9XhRnx2i5UiUcVpMRz3MPAJ8bRsXGrVNLgPLjX3URVJHDMraGmRqwsiDqHQQQMdbJ8jiWaXjEX9Q7ALXlRxwl2g0tbfhCFL9g4NinbKqAFPh32MCHINzTnatMG0G5dgkcyWZuPhOSsY5z" >> /home/cumulus/.ssh/authorized_keys
chmod 700 /home/cumulus
chmod 600 -R /home/cumulus/.ssh/*
chown cumulus:cumulus -R /home/cumulus

#Test for Debian-Based Host
which apt &> /dev/null
if [ "$?" == "0" ]; then
    #These lines will be used when booting on a debian-based box
    echo -e "note: ubuntu device detected"
    #Install LLDP
    apt-get update -qy && apt-get install lldpd -qy
    echo "configure lldp portidsubtype ifname" > /etc/lldpd.d/port_info.conf

    #Replace existing network interfaces file
    echo -e "auto lo" > /etc/network/interfaces
    echo -e "iface lo inet loopback\n\n" >> /etc/network/interfaces
    echo -e  "source /etc/network/interfaces.d/*.cfg\n" >> /etc/network/interfaces

    #Add vagrant interface
    echo -e "\n\nauto vagrant" > /etc/network/interfaces.d/vagrant.cfg
    echo -e "iface vagrant inet dhcp\n\n" >> /etc/network/interfaces.d/vagrant.cfg

    echo -e "\n\nauto eth0" > /etc/network/interfaces.d/eth0.cfg
    echo -e "iface eth0 inet dhcp\n\n" >> /etc/network/interfaces.d/eth0.cfg
fi

#Test for Fedora-Based Host
which yum &> /dev/null
if [ "$?" == "0" ]; then
    echo -e "note: fedora-based device detected"
    /usr/bin/dnf install python -y
    echo -e "DEVICE=vagrant\nBOOTPROTO=dhcp\nONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-vagrant
    echo -e "DEVICE=eth0\nBOOTPROTO=dhcp\nONBOOT=yes" > /etc/sysconfig/network-scripts/ifcfg-eth0
fi


echo "#################################"
echo "   Finished"
echo "#################################"
