#!/bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true    # Run as a superuser and do not ask for a password. Exit status as successful.
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo installing the must-have pre-requisites
git clone https://github.com/StefanSchippers/xschem.git xschem-src
cd xschem-src

./configure
sudo make
sudo make install
cd ..
#
# MAGIC
#download Magic
git clone https://github.com/RTimothyEdwards/magic

cd magic

./configure
sudo make
sudo make install

cd ..

#####=======================
#OPEN PDK
#download Open PDK
git clone https://github.com/RTimothyEdwards/open_pdks
cd open_pdks

./configure
sudo make
sudo make install

#install open_PDK
./configure --enable-sky130-pdk
sudo make -j2
sudo make install

cd ..

######================================
# NGspice
git clone https://git.code.sf.net/p/ngspice/ngspice ngspice-ngspice

cd ./ngspice-ngspice

./autogen.sh --adms #create configure and anable verilog-A compiler
mkdir release
cd release
#--with-x --enable-openmp --enable-adms
../configure  --with-x --with-xspice --enable-openmp --enable-adms --with-readline=yes --disable-debug
sudo make -j4
sudo make install
#sudo apt-get install -y tig
