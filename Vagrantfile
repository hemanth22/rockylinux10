# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  config.vm.box = "Rocky-10-Vagrant-Vbox-10.2"
#  config.vm.box_url="https://dl.rockylinux.org/pub/rocky/10.2/images/x86_64/Rocky-10-Vagrant-Vbox-10.2-20260525.0.x86_64.vagrant.virtualbox.box"
  config.vm.hostname = "rockylinux10"
  config.vm.boot_timeout = 600

  # Disable VirtualBox Guest Additions auto-install (it tries to run dnf before
  # we can fix the TLS/crypto policy, causing SSL connect errors on Rocky 10)
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true
  end

  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
      vb.gui = false
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = "4096"
      vb.cpus = "4"
      #vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "[TASK 1] Update packages"    dnf update -y
    #dnf distro-sync -y
    dnf install -y kernel-headers
    dnf install -y gcc make perl bzip2 elfutils-libelf-devel wget patch libgomp glibc-headers glibc-devel
    dnf install -y kernel-devel
    echo "[TASK 2] Verify packages"
    rpm -q kernel-devel kernel-headers gcc make perl bzip2 elfutils-libelf-devel wget binutils patch libgomp glibc-headers glibc-devel
    dnf clean all
    dnf update ca-certificates
    echo "[TASK 3] Install kmods"
    dnf install -y centos-release-kmods
    dnf install -y kmod-vbox-guest-additions
    dnf install virtualbox-guest-additions kernel-devel-matched -y
  SHELL
end
