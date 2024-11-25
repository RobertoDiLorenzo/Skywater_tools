# Part :one: - Skywater tools
To make the IC simulation with Skywater 130 PDK, i created a script that install the tools to run the first simulation. 
the main tool listed in the script are:

1) Xschem https://xschem.sourceforge.io/stefan/index.html
2) Magic http://opencircuitdesign.com/magic/index.html
3) Open PDK (Skywater 130) http://opencircuitdesign.com/open_pdks/index.html
4) NGspice

## Installation
The process installation is divided in two steps.
First step is about the packages and all dependencies.
From terminal execute this command.

```sh
sudo ./install_packages.sh
```

Now, to install the tools make sure that you have 100GB of free space avalaible on your disk. All the tools will be installed in the default path: "/usr/local/share/".
Open Terminal into "Download" folder. Make sure to have the permission of the administrator and run the command:
```sh
sudo ./tools_install.sh
```

The process will start downloading the latest version of each tool from the official repository of each software.
The compilation of each tool depends on the configuration of your system.

## Run tools
To run Xschem is necessary write in a shell the command:

```
xschem
```
the same process for magic layout tool.
```
magic
```

# Part :two: - Skywater tools for layout
1) Netgen necessary to do LVS. https://opencircuitdesign.com/netgen
2) klayout https://github.com/KLayout/klayout
3) GTKWave https://github.com/gtkwave/gtkwave.git not necessary for layout, it is a another wiever

   
## Installation
Run this command to install the set of tools for making layout and doing LVS.

```sh
sudo ./layout_tools_install.sh
```
## Run tools
tipe in a terminal 
```sh
klayout
```
# Part :three: - Xyce
The official documentation can be found here: https://xyce.sandia.gov/
This is for expert user, this is a parallel electronic simulator.
## Installation 
:warning:
:construction:

## Contributing
Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again!
