
https://cloud-images.ubuntu.com/wsl/

wsl --import Ubuntu C:\WSL\Ubuntu C:\WSL\Ubuntu\ubuntu.tar.gz --version 2

usermod -aG docker $USER
newgrp docker
groups

for net:
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

service docker start


