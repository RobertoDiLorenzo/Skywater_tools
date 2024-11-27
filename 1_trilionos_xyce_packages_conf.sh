#!/bin/bash

# Lista dei pacchetti necessari
packages=(
    gcc
    g++
    gfortran
    make
    cmake
    bison
    flex
    libfl-dev
    libfftw3-dev
    libsuitesparse-dev
    libblas-dev
    liblapack-dev
    libtool
    autoconf
    automake
    git
    libopenmpi-dev
    openmpi-bin
)

# Funzione per verificare se un pacchetto è installato
is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Itera sui pacchetti e verifica se sono installati
missing_packages=()
for package in "${packages[@]}"; do
    if ! is_installed "$package"; then
        missing_packages+=("$package")
    fi
done

# Stampa la lista dei pacchetti mancanti
if [ ${#missing_packages[@]} -gt 0 ]; then
    echo "I seguenti pacchetti sono mancanti:"
    for package in "${missing_packages[@]}"; do
        echo "  * $package"
    done

    # Chiede all'utente se installare i pacchetti mancanti
    read -p "Desideri installare i pacchetti mancanti? (s/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Ss]$ ]]; then
        for package in "${missing_packages[@]}"; do
            echo "Installazione di $package in corso..."
            sudo apt-get install -y "$package"
        done
    else
        echo "Nessun pacchetto sarà installato."
    fi
else
    echo "Tutti i pacchetti sono già installati."
fi

echo "Controllo completato."
