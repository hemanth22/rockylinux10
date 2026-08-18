# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

VAGRANT_EXPERIMENTAL="disks"

Vagrant.configure("2") do |config|
  config.vm.box = "rockylinux10"
  config.vm.hostname = "rockylinux10"
  config.vm.network "private_network", ip: "193.10.10.10"
  #config.vm.provision "shell", path: "bootstrap.sh"
  config.disksize.size = '20GB'
  config.vm.network "public_network",
    use_dhcp_assigned_default_route: true
  config.vm.boot_timeout = 60
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = "4096"
      #vb.memory = "8192" 8GB
      #vb.memory = "1024" 1GB
      vb.cpus = "4"
      #vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end
end
