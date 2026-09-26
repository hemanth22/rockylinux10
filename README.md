# rockylinux10
rockylinux10 vagrant file

## Steps for building vagrant box with rockylinux

## First Download the Vagrant image from Official Repository

```powershell
vagrant box add Rocky-10-Vagrant-Vbox-10.2 https://dl.rockylinux.org/pub/rocky/10.2/images/x86_64/Rocky-10-Vagrant-Vbox-10.2-20260525.0.x86_64.vagrant.virtualbox.box
```

## Bring up vagrant without provision

```powershell
vagrant up --no-provision
```

## Fixing SSL Version in rockylinux

```powershll
vagrant ssh
sudo su -
./provision.sh
```

## Updating packages and install virtualbox guest addition

```shell
dnf -y update
dnf install -y kernel-headers
dnf install -y gcc make perl bzip2 elfutils-libelf-devel wget patch libgomp glibc-headers glibc-devel
dnf install -y kernel-devel
dnf update -y
echo "[TASK 2] Verify packages"
rpm -q kernel-devel kernel-headers gcc make perl bzip2 elfutils-libelf-devel wget binutils patch libgomp glibc-headers glibc-devel
echo "[TASK 3] Install kmods"
dnf install -y centos-release-kmods
dnf install -y kmod-vbox-guest-additions
dnf install virtualbox-guest-additions kernel-devel-matched -y
```


## Reboot vagrant vm

```powershell
vagrant reload
```

## Save the build file

```powershell
vagrant package --vagrantfile vagrant_file/Vagrantfile --output rockylinux10_02.box
```

## Above Steps are tested below Apps

|App Name|Version|
|---|---|
|Vagrant| v2.4.9|
|Oracle Virtual Box| v7.2.18r175117|
