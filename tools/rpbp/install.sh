#!/bin/bash

conda create -y -n rpbp python=3.5
source activate rpbp

conda install -c salford_systems libgcc-6=6.2.0

# Install llvm
conda install -c anaconda llvm
conda install -c numba llvmlite

# Create the anaconda environment.
conda create -n my_new_environment python=3.5 anaconda


# build the package. 
pip install --verbose -r requirements.txt
