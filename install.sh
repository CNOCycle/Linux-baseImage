#!/bin/bash

# Download image
# lnk: https://ubuntu.com/download


# set the fastest mirror server
SED_APT_OLD="http://[A-Za-z.]*.ubuntu.com/ubuntu/\?"
SED_APT_NEW="mirror://mirrors.ubuntu.com/mirrors.txt"
sudo sed -i "s|${SED_APT_OLD}|${SED_APT_NEW}|g" /etc/apt/sources.list


# install essential tools
sudo apt update && \
sudo apt install -y gnupg2 ca-certificates curl wget \
                 bash-completion build-essential make rsync git \
                 vim \
                 tmux \
                 openssh-server


# clear cache (optional)
# rm -rf /var/lib/apt/lists/*


# setup network
sudo vim /etc/netplan/01-network-manager-all.yaml
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ${INTERFACE}:
      addresses: [AAA.BBB.CCC.DDD/24]
      gateway4: AAA.BBB.CCC.DDD
      nameservers:
        addresses: [8.8.8.8]
```
sudo netplan try


# install nvidia-driver
# ref: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.3.0/ubuntu20.04/base/Dockerfile
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | sudo apt-key add - && \
echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list && \
sudo apt update && \
apt install -y nvidia-driver-470 && \
sudo reboot


# install docker
sudo apt update && \
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
sudo apt update && \
sudo apt install -y docker-ce docker-ce-cli containerd.io && \
sudo groupadd docker && \
sudo usermod -aG docker ${USER}


# install nvidia-docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list && \
sudo apt update && \
sudo apt install -y nvidia-docker2 && \
sudo systemctl restart docker


# install vscode
sudo apt update && \
    sudo apt install -y software-properties-common apt-transport-https wget && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
    sudo apt install -y code


# install conda
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp//miniconda.sh -f -b -p ${HOME}/opt/miniconda && \
    rm /tmp/miniconda.sh

# set git configuration
git config --global core.editor vim && \
git config --global user.name ${USER} && \
git config --global user.email ${USER}@github.com

#######################################################################################
# fix network prority
sudo nmcli connection modify public_ip ipv4.route-metric 90
nmcli connection up public_ip 

# install docker
## useful command
#docker rm $(docker ps -f="status=exited" -q) # remove all exited docker containers
#docker rmi $(docker images -f "dangling=true" -q) # remove all <none> images
#docker stop $(docker ps -a -q)
#docker rm $(docker ps -a -q)

# vim -> remembering last position
# cat /etc/vim/vimrc or ~/.vimrc
#" Uncomment the following to have Vim jump to the last position when
#" reopening a file
#"if has("autocmd")
#"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
#"endif

# vim -> Highlight searches
# cat /etc/vim/vimrc or ~/.vimrc
# set hlsearch
# clear last search lighlight
# :noh

# acestream
echo 'deb http://repo.acestream.org/ubuntu/ trusty main' | sudo tee /etc/apt/sources.list.d/acestream.list
sudo wget -O - http://repo.acestream.org/keys/acestream.public.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install --no-install-recommends python python-psutil python-pexpect python-notify2 acestream-engine vlc
git clone https://github.com/jonian/acestream-launcher.git
sudo bash ./install.sh
#acestream-launcher acestream://edca97797b5749855c9c0d512312312312323

# for coding
:'
// sed script for replacing MS'endline format with Linux's
#sed $'s/\r$//'     # DOS to Unix
#sed $'s/$/\r/'     # Unix to DOS

// sed script for replace tab with 4 spaces
sed -i $'s/\t/    /g' file

// sed script for removing white space from the end of line in linux
sed -i 's/[[:blank:]]*$//' file

// sed script for replacing multiple empty line with one empty line?
sed -i '/^$/N;/^\n$/D' file
'
