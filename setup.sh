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

echo ". . . . . Update + Upgrade"
# Build and install radare2 on master branch
DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 && apt-get -y -q update

echo ". . . . . Dependencies"
# Install Dependencies
apt-get -y -q install -y \
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
apt-get -y -q install python-pip python-dev build-essential 
pip install --upgrade pip 
pip install --upgrade virtualenv 

echo ". . . . . Nodejs"
# nodejs
apt-get -y -q install gcc g++ make
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get -y -q update
apt-get -y -q install nodejs

echo ". . . . . tldr"
npm install -g tldr

echo ". . . . . yarn for nodejs"
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn

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

echo ". . . . . gdb"
apt-get -y -q install -y gdb

# echo ". . . . . gdb-dashboard"
# wget -P ~ git.io/.gdbinit

echo ". . . . . PEDA"
cd /home/vagrant
git clone https://github.com/longld/peda.git /home/vagrant/peda
echo "source /home/vagrant/peda/peda.py" >> ~/.gdbinit

echo ". . . . . VOLTRON"
cd /home/vagrant
git clone https://github.com/snare/voltron
./voltron/install.sh -s
echo "source /path/to/voltron/entry.py" >> /home/vagrant/.gdbinit

# echo ". . . . . GEF"
# wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
# apt-get -y -q install python3-pip
# python3 -m pip install capstone unicorn keystone-engine ropper

echo ". . . . . Pwntools"
apt-get -y -q install binutils python-dev python2.7 python-pip libssl-dev libffi-dev build-essential
python2 -m pip install --upgrade pip
python2 -m pip install --upgrade pwntools

echo ". . . . . Fish shell"
apt-add-repository -y ppa:fish-shell/release-2
apt-get -q update
apt-get -q -y install fish
echo "/usr/bin/fish" | tee -a /etc/shells
chsh -s /usr/bin/fish

echo ". . . . . . . . . . "
echo "- CORE DUMP CONFIG -"
echo ". . . . . . . . . . "
mkdir -p /tmp/core_dump
chmod 777 /tmp/core_dump
echo "/proc/sys/kernel/core_pattern : "
echo "/tmp/core_dump.%s.%e.%p" | tee /proc/sys/kernel/core_pattern
echo "/proc/sys/fs/suid_dumpable    : "
cat /proc/sys/fs/suid_dumpable
echo "seting : ulimit -c unlimited    "
ulimit -c unlimited

sysctl -w kernel.randomize_va_space=0

echo ". . . . . Reconfigure locale"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
sudo dpkg-reconfigure locales

echo ". . . . . cleanup"
# Cleanup
apt-get autoremove --purge -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# echo ". . . . . exercises compilation"
# /utils/compile-all-exercises
