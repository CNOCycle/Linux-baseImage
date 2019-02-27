#!/bin/bash
# Download image
#https://help.ubuntu.com/community/Installation/MinimalCD

# set the fastest mirror server
SED_APT_OLD="http://[A-Za-z.]*.ubuntu.com/ubuntu/\?"
SED_APT_NEW="mirror://mirrors.ubuntu.com/mirrors.txt"
sudo sed -i "s|${SED_APT_OLD}|${SED_APT_NEW}|g" /etc/apt/sources.list

# install package
sudo apt-get update && \
    apt-get install -qq --no-install-recommends \
    vim                                              \
    sshd                          `#ssh service`     \
    gcc g++                       `# c/c++ compiler` \
    python-pip python-dev python-setuptools `# python tool`

# clear cache (optional)
# rm -rf /var/lib/apt/lists/*

# install docker
cd /tmp
git clone https://github.com/rancher/install-docker
cd install-docker/
sudo bash -e 17.10.sh
sudo groupadd docker
sudo usermod -aG docker $USER
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
