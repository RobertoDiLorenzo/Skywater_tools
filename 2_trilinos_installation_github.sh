#!/bin/bash

# Definisci variabili comuni
TRILINOS_VERSION="github_version"
TRILINOS_TARBALL="Trilinos-trilinos-release-$TRILINOS_VERSION.tar.gz"
DOWNLOAD_DIR="/home/$USER/Downloads"
INSTALL_DIR="/home/$USER/XyceLibs"
SOURCE_DIR="/home/$USER/Trilinos$TRILINOS_VERSION"
FLAGS="-O1 -fPIC" # for powerfull PC "-O3 -fpic"
nproc="2"
# Crea la directory di origine
mkdir -p "$SOURCE_DIR"
cd "$SOURCE_DIR"

# Scarica il pacchetto Trilinos se non è presente
if [ ! -d "$DOWNLOAD_DIR/Trilinos" ]; then
    echo "Scaricamento di Trilinos dalla repository GitHub..."
    git clone https://github.com/trilinos/Trilinos.git "$DOWNLOAD_DIR/Trilinos"
else
    echo "Il repository Trilinos è già presente nella directory $DOWNLOAD_DIR."
    read -p "Desideri sovrascrivere il repository esistente? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -rf "$DOWNLOAD_DIR/Trilinos"
        echo "Scaricamento di Trilinos dalla repository GitHub..."
        git clone https://github.com/trilinos/Trilinos.git "$DOWNLOAD_DIR/Trilinos"
    fi
fi

# Percorso completo della directory sorgente
SRCDIR="$DOWNLOAD_DIR/Trilinos"

# Funzione per configurare e costruire Trilinos
# Configura e costruisci Trilinos

build_trilinos() {
    local archdir=$1
    local enable_mpi=$2
    local build_type=$3

    rm -rf  "$archdir/build_$build_type"

	mkdir -p "$archdir/build_$build_type"
    cd "$archdir/build_$build_type"
	
    cmake "$SRCDIR"\
      -G "Unix Makefiles" \
      -DCMAKE_C_COMPILER=gcc \
      -DCMAKE_CXX_COMPILER=g++ \
      -DCMAKE_Fortran_COMPILER=gfortran \
      -DCMAKE_CXX_FLAGS="$FLAGS" \
      -DCMAKE_C_FLAGS="$FLAGS" \
      -DCMAKE_Fortran_FLAGS="$FLAGS" \
      -DCMAKE_INSTALL_PREFIX="$archdir" \
      -DCMAKE_MAKE_PROGRAM="make" \
      -DTrilinos_ENABLE_NOX=ON \
      -DNOX_ENABLE_LOCA=ON \
      -DTrilinos_ENABLE_EpetraExt=ON \
      -DEpetraExt_BUILD_BTF=ON \
      -DEpetraExt_BUILD_EXPERIMENTAL=ON \
      -DEpetraExt_BUILD_GRAPH_REORDERINGS=ON \
      -DTrilinos_ENABLE_TrilinosCouplings=ON \
      -DTrilinos_ENABLE_Ifpack=ON \
      -DTrilinos_ENABLE_AztecOO=ON \
      -DTrilinos_ENABLE_Belos=ON \
      -DTrilinos_ENABLE_Teuchos=ON \
      -DTrilinos_ENABLE_COMPLEX_DOUBLE=ON \
      -DTrilinos_ENABLE_Amesos=ON \
        -DAmesos_ENABLE_KLU=ON \
      -DTrilinos_ENABLE_Amesos2=ON \
        -DAmesos2_ENABLE_KLU2=ON \
        -DAmesos2_ENABLE_Basker=ON \
      -DTrilinos_ENABLE_Sacado=ON \
      -DTrilinos_ENABLE_Stokhos=ON \
      -DTrilinos_ENABLE_Kokkos=ON \
      -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
      -DTrilinos_ENABLE_CXX11=ON \
      -DTPL_ENABLE_AMD=ON \
      -DAMD_LIBRARY_DIRS="/usr/lib" \
      -DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" \
      -DTPL_ENABLE_BLAS=ON \
      -DTPL_ENABLE_LAPACK=ON
      #$SRCDIR       # <--- Use SRCDIR as the source directory

    export MAKEFLAGS=-j2
	
    # Compila e installa
    make #-j$(nproc)
    sudo make install
}

# Create installation directories
mkdir -p "$INSTALL_DIR/Serial"
mkdir -p "$INSTALL_DIR/Parallel"

# Configura e costruisci Trilinos
echo "Compilazione e installazione di Trilinos (Seriale)"
build_trilinos "$INSTALL_DIR/Serial" "" "serial"

echo "Compilazione e installazione di Trilinos (Parallela)"
build_trilinos "$INSTALL_DIR/Parallel" "mpicc" "parallel"
