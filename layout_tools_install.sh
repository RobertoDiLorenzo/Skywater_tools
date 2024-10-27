#!/bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true    # Run as a superuser and do not ask for a password. Exit status as successful.
test $? -eq 0 || { echo "You should have sudo privilege to run this script"; exit 1; }

echo installing the must-have pre-requisites

if ! command -v git &> /dev/null; then
    echo "git is not installed. Installing..."
    sudo apt-get install -y git
fi

#####################
# NETGEN
#####################

git clone git://opencircuitdesign.com/netgen
cd netgen
./configure
make
sudo make install

cd ..

############################
#### check to validate the requirement for klayout
############################

# Define the packages to check and install
packages=(
  "gcc"
  "g++"
  "make"
  "qtbase5-dev"
  "qttools5-dev"
  "libqt5xmlpatterns5-dev"
  "qtmultimedia5-dev"
  "libqt5multimediawidgets5"
  "libqt5svg5-dev"
  "ruby"
  "ruby-dev"
  "python3"
  "python3-dev"
  "libz-dev"
  "libgit2-dev"
)

# Check and install each package
for package in "${packages[@]}"; do
  if ! dpkg -s "$package" > /dev/null; then
    echo "Installing $package..."
    sudo apt-get install -y "$package"
  else
    echo "$package is already installed."
  fi
done

#############################
# klayout
#############################
git clone https://github.com/KLayout/klayout
cd klayout
./build.sh

cd ..

#################################
# GTKWave
#################################
sudo apt-get install build-essential meson gperf flex desktop-file-utils libgtk-3-dev \
            libbz2-dev libjudy-dev libgirepository1.0-dev

git clone https://github.com/gtkwave/gtkwave.git
cd gtkwave
meson setup build
meson compile -C build

# Download from http://gtkwave.sourceforge.net/
wget http://gtkwave.sourceforge.net/gtkwave-3.3.121.tar.gz
tar -xvzf gtkwave-3.3.121.tar.gz
mv gtkwave-3.3.121 gtkwave
rm gtkwave-3.3.121.tar.gz
cd gtkwave
./configure
make
sudo make install

cd ..
