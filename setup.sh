echo "========== ==================== =========="
echo "========== RUNNING SETUP SCRIPT =========="
echo "========== ==================== =========="

# Custom r2 build 
# ========
# nodejs
# python + pip
# r2
# r2pipe
# r2frida
# r2dec
#
# Takes your custom config file (.radare2rc) from the current directory
# Copies contents of ./data to /home/r2/data
#

echo ". . . . . Update + Upgrade"
# Build and install radare2 on master branch
DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 && apt-get -y -qq update

echo ". . . . . Dependencies"
# Install Dependencies
apt-get -y -qq install -y \
  curl \
  gcc \
  git \
  bison \
  pkg-config \
  make \
  glib-2.0 \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  gnupg2 \
  sudo \
  xz-utils \
  openssl \
  build-essential \
  libc6 \
  libc6-dev \
  g++-multilib \
  nasm \

echo ". . . . . Python + pip + virtualenv"
apt-get -y -qq install python-pip python-dev build-essential 
pip install --upgrade pip 
pip install --upgrade virtualenv 

echo ". . . . . Nodejs"
# nodejs
apt-get -y -qq install gcc g++ make
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get -y -qq update
apt-get -y -qq install nodejs

echo ". . . . . yarn for nodejs"
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

echo ". . . . . r2"
# r2
git clone -q --depth 1 https://github.com/radare/radare2.git && ./radare2/sys/install.sh

echo ". . . . . r2pipe"
# r2pipe
pip install r2pipe && npm install --unsafe-perm -g r2pipe

echo ". . . . . r2pm"
# Setup r2pm
r2pm init && r2pm update

echo ". . . . . r2dec"
# r2dec plugin
# command pdd
# .radare2rc options:
#   r2dec.casts         | if false, hides all casts in the pseudo code.
#   r2dec.asm           | if true, shows pseudo next to the assembly.
#   r2dec.blocks        | if true, shows only scopes blocks.
#   r2dec.paddr         | if true, all xrefs uses physical addresses compare.
#   r2dec.xrefs         | if true, shows all xrefs in the pseudo code.
#   r2dec.theme         | defines the color theme to be used on r2dec.
#   e scr.html          | outputs html data instead of text.
#   e scr.color         | enables syntax colors.
r2pm -ci r2dec

echo ". . . . . r2frida"
# r2frida plugin
# Forms of use:
# $ r2 frida://Twitter
# $ r2 frida://1234
# $ r2 frida:///bin/ls
# $ r2 frida://"/bin/ls -al"
# $ r2 frida://device-id/Twitter
r2pm -ci r2frida

echo ". . . . . cleanup"
# Cleanup
apt-get autoremove --purge -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo ". . . . . gdb"
apt-get -y -qq update
apt-get -y -qq install -y gdb

# echo ". . . . . gdb-dashboard"
# wget -P ~ git.io/.gdbinit

# echo ". . . . . PEDA"
# git clone https://github.com/longld/peda.git ~/peda
# echo "source ~/peda/peda.py" >> ~/.gdbinit

# echo ". . . . . Pwntools"
# apt-get -y -qq install libssl-dev libffi-dev
# pip install --upgrade pwntools

echo ". . . . . GEF"
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh


echo ". . . . . Pwntools"
sudo apt-get -y -qq update
sudo apt-get -y -qq install binutils python-dev python2.7 python-pip libssl-dev libffi-dev build-essential
sudo pip install --upgrade pip
sudo pip install --upgrade pwntools


echo ". . . . . Fish shell"
apt-add-repository -y ppa:fish-shell/release-2
apt-get -qq update
apt-get -qq -y install fish
echo "/usr/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/bin/fish