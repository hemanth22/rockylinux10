https://dl.rockylinux.org/pub/rocky/10/images/x86_64/  

[root@localhost ~]# cat /etc/yum.repos.d/rocky.repo
[baseos]
name=Rocky Linux 10 - BaseOS
baseurl=http://dl.rockylinux.org/vault/rocky/10.0/BaseOS/x86_64/os/
enabled=1
gpgcheck=0

[appstream]
name=Rocky Linux 10 - AppStream
baseurl=http://dl.rockylinux.org/vault/rocky/10.0/AppStream/x86_64/os/
enabled=1
gpgcheck=0

[crb]
name=Rocky Linux 10 - CRB
baseurl=http://dl.rockylinux.org/vault/rocky/10.0/CRB/x86_64/os/
enabled=1
gpgcheck=0

cat /dev/null > /etc/yum.repos.d/rocky.repo

sudo tee /etc/yum.repos.d/rocky.repo <<'EOF'
[baseos]
name=Rocky Linux 10 - BaseOS
baseurl=http://dl.rockylinux.org/vault/rocky/10.0/BaseOS/x86_64/os/
enabled=1
gpgcheck=0

[appstream]
name=Rocky Linux 10 - AppStream
baseurl=http://dl.rockylinux.org/vault/rocky/10.0/AppStream/x86_64/os/
enabled=1
gpgcheck=0

[crb]
name=Rocky Linux 10 - CRB
baseurl=http://dl.rockylinux.org/vault/rocky/10.0/CRB/x86_64/os/
enabled=1
gpgcheck=0
EOF
