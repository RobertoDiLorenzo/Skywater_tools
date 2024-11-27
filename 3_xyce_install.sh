#!/bin/bash

# Variabili globali
TRILINOS_VERSION="github_version"
TRILINOS_INSTALL_DIR="$HOME/XyceLibs"
XYCE_INSTALL_DIR="$HOME/XyceInstall"
BUILD_DIR="$HOME/xyce_build"
DOWNLOAD_DIR="$HOME/Downloads"
TRILINOS_SOURCE_DIR="$DOWNLOAD_DIR/Trilinos"
XYCE_VERSION="7.8"
XYCE_TAR_URL="https://xyce.sandia.gov/files/xyce/Xyce-${XYCE_VERSION}.tar.gz"
XYCE_TAR_FILE="$DOWNLOAD_DIR/Xyce-${XYCE_VERSION}.tar.gz"
XYCE_SOURCE_DIR="$DOWNLOAD_DIR/Xyce-${XYCE_VERSION}"
NPROC=$(nproc)

# Funzione per verificare se un comando esiste
command_exists() {
    command -v "$1" &> /dev/null
}
sudo apt update
sudo apt install -y libnetcdf-dev libhdf5-dev
# Funzione per configurare Trilinos
build_trilinos() {
    echo "Configurazione e compilazione di Trilinos..."
    mkdir -p "$TRILINOS_INSTALL_DIR"
    mkdir -p "$BUILD_DIR/trilinos_build"
    cd "$BUILD_DIR/trilinos_build" || exit 1

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

    make -j"$NPROC" || { echo "Errore durante la compilazione di Trilinos"; exit 1; }
    make install || { echo "Errore durante l'installazione di Trilinos"; exit 1; }
}

# Funzione per configurare Xyce
build_xyce() {
    echo "Configurazione e compilazione di Xyce..."
    mkdir -p "$XYCE_INSTALL_DIR"
    mkdir -p "$BUILD_DIR/xyce_build"
    cd "$BUILD_DIR/xyce_build" || exit 1

    cmake "$XYCE_SOURCE_DIR" \
        -DCMAKE_INSTALL_PREFIX="$XYCE_INSTALL_DIR" \
        -DTrilinos_DIR="$TRILINOS_INSTALL_DIR" \
        -DCMAKE_C_COMPILER=gcc \
        -DCMAKE_CXX_COMPILER=g++ \
        -DCMAKE_BUILD_TYPE=Release

    make -j"$NPROC" || { echo "Errore durante la compilazione di Xyce"; exit 1; }
    make install || { echo "Errore durante l'installazione di Xyce"; exit 1; }
}

# Installazione delle dipendenze di sistema
echo "Installazione delle dipendenze di sistema..."
sudo apt update
sudo apt install -y build-essential cmake gfortran liblapack-dev libblas-dev

# Scaricamento di Trilinos
if [ ! -d "$TRILINOS_SOURCE_DIR" ]; then
    echo "Scaricamento di Trilinos..."
    git clone https://github.com/trilinos/Trilinos.git "$TRILINOS_SOURCE_DIR" || { echo "Errore durante il download di Trilinos"; exit 1; }
else
    echo "Trilinos è già presente. Procedo con l'installazione."
fi

# Compilazione e installazione di Trilinos
build_trilinos

# Scaricamento di Xyce
if [ ! -f "$XYCE_TAR_FILE" ]; then
    echo "Scaricamento di Xyce..."
    curl -o "$XYCE_TAR_FILE" "$XYCE_TAR_URL" || { echo "Errore durante il download di Xyce"; exit 1; }
fi

# Estrazione del pacchetto Xyce
if [ ! -d "$XYCE_SOURCE_DIR" ]; then
    echo "Estrazione di Xyce..."
    mkdir -p "$XYCE_SOURCE_DIR"
    tar -xzf "$XYCE_TAR_FILE" -C "$DOWNLOAD_DIR" || { echo "Errore durante l'estrazione di Xyce"; exit 1; }
else
    echo "Il pacchetto Xyce è già estratto. Procedo con l'installazione."
fi

# Compilazione e installazione di Xyce
build_xyce

echo "Installazione completata con successo!"
