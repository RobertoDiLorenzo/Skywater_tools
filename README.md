# Skywater_tools
To make the IC simulation with Skywater 130 PDK, i created a script that install the tools to run the first simulation. 
the main tool listed in the script are:
1) Xschem https://xschem.sourceforge.io/stefan/index.html
2) Magic http://opencircuitdesign.com/magic/index.html
3) Open PDK (Skywater 130) http://opencircuitdesign.com/open_pdks/index.html
4) NGspice

## Installation
The process installation is divided in two steps.
the first step is abot the packages and all dependencies.
From terminal execute this command.

sudo ./install_packages

Now, to install the tools make sure that you have 100GB of free space avalaible on your disk. All the tools will be installed in the default path: "/usr/local/share/".
Open Terminal into "Download" folder. Make sure to have the permission of the administrator and run the command:

sudo ./tools_install.sh

The process will start downloading the latest version of each tool from the official repository of each software.
The compilation of each tool depends on the configuration of your system.
