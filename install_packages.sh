#!/bin/bash

set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true    # Run as a superuser and do not ask for a password. Exit status as successful.
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    nautilus 
    gedit 
    x11-apps 
    build-essential 
    flex 
    bison 
    m4 
    tcsh 
    csh 
    libx11-dev 
    tcl-dev 
    tk-dev 
    libcairo2 
    libcairo2-dev 
    libx11-6 
    libxcb1 libx11-xcb-dev libxrender1 libxrender-dev libxpm4 libxpm-dev libncurses-dev 
    blt freeglut3 mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev tcl-tclreadline libgtk-3-dev 
    tcl8.6 tcl8.6-dev tk8.6 tk8.6-dev 
    gawk 
    graphicsmagick 
    vim-gtk3 
    libxaw7 
    libxaw7-dev fontconfig libxft-dev libxft2 
    libxmu6 libxext-dev libxext6 libxrender1 
    libxrender-dev libtool readline-common libreadline-dev gawk autoconf libtool automake adms gettext ruby-dev 
    python3-dev 
    qtmultimedia5-dev 
    libqt5multimediawidgets5 libqt5multimedia5-plugins libqt5multimedia5 libqt5xmlpatterns5-dev 
    python3-pyqt5 qtcreator pyqt5-dev-tools 
    libqt5svg5-dev gcc g++ gfortran 
    make cmake bison flex 
    libfl-dev libfftw3-dev libsuitesparse-dev libblas-dev liblapack-dev libtool autoconf automake libopenmpi-dev 
    openmpi-bin 
    python3-pip 
    python3-venv python3-virtualenv python3-numpy 
    rustc libprotobuf-dev 
    protobuf-compiler 
    libopenmpi-dev 
    gnat 
    gperf 
    liblzma-dev 
    libgtk2.0-dev 
    swig 
    libboost-all-dev
    wget
    libwww-curl-perl
EOF
)

echo installing the nice-to-have pre-requisites
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 6

sudo apt-get install -y tig
