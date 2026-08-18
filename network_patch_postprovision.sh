ip route show
nmcli connection show
nmcli connection modify "System eth2" ipv4.route-metric 100
nmcli connection modify "System eth0" ipv4.route-metric 300
echo "Reboot server with vagrant reload"


ping -I enp0s3 -c 10 google.com
ping -I enp0s9 -c 10 google.com
ping -I enp0s8 -c 10 google.com

nmcli connection modify "Wired connection 1" ipv4.route-metric 100
nmcli connection modify "Wired connection 2" ipv4.route-metric 300

# Ping using enp0s3
ping -I enp0s3 -c 5 8.8.8.8

# Ping using enp0s9
ping -I enp0s9 -c 5 8.8.8.8

# Ping using enp0s8
ping -I enp0s8 -c 5 8.8.8.8



sudo ip link set dev enp0s3 mtu 1400
sudo ip link set dev enp0s8 mtu 1400
sudo ip link set dev enp0s9 mtu 1400
curl -I https://mirrors.rockylinux.org/



echo "minrate=1k" | sudo tee -a /etc/dnf/dnf.conf
echo "timeout=120" | sudo tee -a /etc/dnf/dnf.conf
# Note: DNF/curl under Rocky 10 uses OpenSSL 3. We have to tell the system crypto policy to allow older TLS versions
sudo update-crypto-policies --set DEFAULT:FEDORA32

# Finally, clean and test
sudo dnf clean all
sudo dnf makecache

dnf install ca-certificates
# or if it's already installed, force an update:
dnf upgrade ca-certificates
update-ca-trust force-enable
update-ca-trust extract
