#!/bin/bash

### https://docs.mattermost.com/install/installing-mattermost-omnibus.html 
### Install Instructions |^|
### For Ubuntu Jammy - 22.04 LTS, Ubuntu Noble - 24.04 LTS

set -e

# sudo rm /usr/share/keyrings/mattermost-archive-keyring.gpg
### Uncomment if not new server |^|

curl -sL -o- https://deb.packages.mattermost.com/pubkey.gpg |  gpg --dearmor | sudo tee /usr/share/keyrings/mattermost-archive-keyring.gpg > /dev/null

curl -o- https://deb.packages.mattermost.com/repo-setup.sh | sudo bash

sudo apt install mattermost-omnibus -y
