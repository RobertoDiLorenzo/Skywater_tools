#!/bin/bash

# Variabili globali
TRILINOS_VERSION="16-0-0"
TRILINOS_TAR_URL="https://github.com/trilinos/Trilinos/archive/refs/tags/trilinos-release-$TRILINOS_VERSION.tar.gz"
TRILINOS_TAR_FILE="$HOME/Downloads/trilinos-release-$TRILINOS_VERSION.tar.gz"
TRILINOS_SOURCE_DIR="$HOME/Downloads/Trilinos-trilinos-release-$TRILINOS_VERSION"
TRILINOS_INSTALL_DIR="$HOME/XyceLibs"
XYCE_VERSION="7.8"
XYCE_TAR_URL="https://xyce.sandia.gov/files/xyce/Xyce-${XYCE_VERSION}.tar.gz"
XYCE_TAR_FILE="$HOME/Downloads/Xyce-${XYCE_VERSION}.tar.gz"
XYCE_SOURCE_DIR="$HOME/Downloads/Xyce-${XYCE_VERSION}"
XYCE_INSTALL_DIR="$HOME/XyceInstall"
BUILD_DIR="$HOME/xyce_build"
NPROC="6"   #$(nproc)

# Installazione delle dipendenze di sistema
echo "Installazione delle dipendenze di sistema..."
sudo apt update
sudo apt install -y build-essential cmake gfortran liblapack-dev libblas-dev libnetcdf-dev libhdf5-dev curl

# Scaricamento di Trilinos
echo "Scaricamento di Trilinos..."
if [ ! -f "$TRILINOS_TAR_FILE" ]; then
    curl -L -o "$TRILINOS_TAR_FILE" "$TRILINOS_TAR_URL" || { echo "Errore durante il download di Trilinos"; exit 1; }
fi

# Estrazione di Trilinos
if [ ! -d "$TRILINOS_SOURCE_DIR" ]; then
    echo "Estrazione di Trilinos..."
    mkdir -p "$HOME/Downloads"
    tar -xzf "$TRILINOS_TAR_FILE" -C "$HOME/Downloads" || { echo "Errore durante l'estrazione di Trilinos"; exit 1; }
fi

# Creazione della directory di build per Trilinos
mkdir -p "$BUILD_DIR/trilinos_build"
cd "$BUILD_DIR/trilinos_build" || exit 1

# Compilazione di Trilinos
echo "Compilazione di Trilinos..."
cmake "$TRILINOS_SOURCE_DIR" \
    -DCMAKE_INSTALL_PREFIX="$TRILINOS_INSTALL_DIR" \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_Fortran_COMPILER=gfortran \
    -DCMAKE_BUILD_TYPE=Release \
    -DTPL_ENABLE_Netcdf=ON \
    -DTPL_Netcdf_INCLUDE_DIRS=/usr/include \
    -DTPL_Netcdf_LIBRARY_DIRS=/usr/lib/x86_64-linux-gnu \
    -DTrilinos_ENABLE_ALL_PACKAGES=OFF \
    -DTrilinos_ENABLE_Amesos=ON \
    -DTrilinos_ENABLE_Epetra=ON \
    -DTrilinos_ENABLE_EpetraExt=ON \
    -DTrilinos_ENABLE_Ifpack=ON \
    -DTrilinos_ENABLE_NOX=ON \
    -DTrilinos_ENABLE_Teuchos=ON \
    -DTrilinos_ENABLE_Belos=ON \
    -DTrilinos_ENABLE_AztecOO=ON \
    -DTrilinos_ENABLE_TrilinosCouplings=ON \
    -DTrilinos_ENABLE_Sacado=ON \
    -DTrilinos_ENABLE_Amesos2=ON \
    -DAmesos_ENABLE_KLU=ON \
    -DAmesos2_ENABLE_KLU2=ON \
    -DTPL_ENABLE_BLAS=ON \
    -DTPL_ENABLE_LAPACK=ON

sudo make -j"$NPROC" || { echo "Errore durante la compilazione di Trilinos"; exit 1; }
sudo make install || { echo "Errore durante l'installazione di Trilinos"; exit 1; }

# Scaricamento di Xyce
echo "Scaricamento di Xyce..."
if [ ! -f "$XYCE_TAR_FILE" ]; then
    curl -o "$XYCE_TAR_FILE" "$XYCE_TAR_URL" || { echo "Errore durante il download di Xyce"; exit 1; }
fi

# Estrazione di Xyce
if [ ! -d "$XYCE_SOURCE_DIR" ]; then
    echo "Estrazione di Xyce..."
    tar -xzf "$XYCE_TAR_FILE" -C "$HOME/Downloads" || { echo "Errore durante l'estrazione di Xyce"; exit 1; }
fi

# Creazione della directory di build per Xyce
mkdir -p "$BUILD_DIR/xyce_build"
cd "$BUILD_DIR/xyce_build" || exit 1

# Compilazione di Xyce
echo "Compilazione di Xyce..."
cmake "$XYCE_SOURCE_DIR" \
    -DCMAKE_INSTALL_PREFIX="$XYCE_INSTALL_DIR" \
    -DTrilinos_DIR="$TRILINOS_INSTALL_DIR" \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_BUILD_TYPE=Release

sudo make -j"$NPROC" || { echo "Errore durante la compilazione di Xyce"; exit 1; }
sudo make install || { echo "Errore durante l'installazione di Xyce"; exit 1; }

echo "Installazione completata con successo!"
