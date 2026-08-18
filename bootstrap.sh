#!/bin/bash

# Enable ssh password authentication
echo "[TASK 1] Enable ssh password authentication"
#sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config #Decommission from RHEL9
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#echo "PermitRootLogin yes" >> /etc/ssh/sshd_config #Decommission from RHEL9
systemctl reload sshd

# Set Root password
echo "[TASK 2] Set root password"
echo -e "hemanth\nhemanth" | passwd root >/dev/null 2>&1

#echo "[TASK 3] Enable mirrorlist"
#sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*

#echo "[TASK 4] Enable repo"
#sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

#echo "[TASK 5] Ensure to install centos-release-stream"
#dnf install centos-release-stream -y

#echo "[TASK 6] Ensure to install centos-linux-stream"
#dnf swap centos-{linux,stream}-repos -y

echo "[TASK 7] Ensure to install distro-sync"
dnf distro-sync -y

echo "[TASK 8] Ensure to install git"
dnf install git -y

echo "[TASK 9] Ensure to install Perl"
dnf install perl -y

echo "[TASK 10] Ensure to install zip tools"
dnf install gzip zip -y

echo "[TASK 11] Ensure to install Perl"
dnf install podman -y

echo "[TASK 12] Ensure to install wget"
dnf install wget -y

echo "[TASK 13] Ensure to install net-tools"
dnf install net-tools -y

echo "[TASK 14] Ensure to install bind-utils"
dnf install bind-utils -y

echo "[TASK 15] Ensure to install epel-release"
dnf install epel-release -y

echo "[TASK 16] Ensure to install tree"
dnf -y install tree

echo "[TASK 17] Ensure to install tree"
dnf install -y vsftpd

#echo "[TASK 18] Ensure to install python3"
#dnf install python3 -y

#echo "[TASK 19] Ensure to install python38"
#dnf module install python38 -y

#echo "[TASK 20] Ensure to upgrade pip in python38"
#python3.8 -m pip install --upgrade pip

#echo "[TASK 21] Ensure to install wheel in python38"
#python3.8 -m pip install wheel

#echo "[TASK 22] Ensure to install ansible in python38"
#python3.8  -m pip install ansible

echo "[TASK 23] Ensure to install strace"
dnf install -y strace

echo "[TASK 24] Ensure to install traceroute"
dnf install -y traceroute

echo "[TASK 25] Ensure to install sysstat"
dnf install -y sysstat

echo "[TASK 26] Ensure to install netcat"
dnf install -y netcat
#ansible-pull -U https://github.com/hemanth22/ansible-pull-vsftpd.git
