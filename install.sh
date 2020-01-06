#!/bin/bash
# Download image
#https://help.ubuntu.com/community/Installation/MinimalCD

# set the fastest mirror server
SED_APT_OLD="http://[A-Za-z.]*.ubuntu.com/ubuntu/\?"
SED_APT_NEW="mirror://mirrors.ubuntu.com/mirrors.txt"
sudo sed -i "s|${SED_APT_OLD}|${SED_APT_NEW}|g" /etc/apt/sources.list

# clear cache (optional)
# rm -rf /var/lib/apt/lists/*

# update repos
apt update

# install ensessntail tools
apt install -y --no-install-recommends gnupg2 ca-certificates curl wget

# install Makefile
apt install -y make

# install editor
apt install -y vim

# install tmux
apt install -y tmux

# install sshd
apt install -y openssh-server

# install nvidia's ppa
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# install GPU driver
apt update && \
apt install -y nvidia-driver-440

# install docker
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
apt-key fingerprint 0EBFCD88 && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" && \
apt update && \
apt install -y docker-ce docker-ce-cli containerd.io

# install nvidia-docker
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  tee /etc/apt/sources.list.d/nvidia-docker.list
apt-get update && \
apt install -y nvidia-docker2 && \
pkill -SIGHUP dockerd

# set docker's permission
sudo groupadd docker && \
sudo usermod -aG docker $USER

# install vscode
sudo apt update && \
    sudo apt install -y software-properties-common apt-transport-https wget && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
    sudo apt install -y code

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
