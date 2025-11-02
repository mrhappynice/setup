
https://cloud-images.ubuntu.com/wsl/

wsl --import Ubuntu C:\WSL\Ubuntu C:\WSL\Ubuntu\ubuntu.tar.gz --version 2

usermod -aG docker $USER
newgrp docker
groups

service docker start


