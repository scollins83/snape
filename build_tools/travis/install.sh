#!/usr/bin/env bash

set -e

if [[ "$DISTRIB" == "conda" ]]; then
    # Deactivate the travis-provided virtual environment and setup a
    # conda-based environment instead
    deactivate

    # Use the miniconda installer for faster download / install of conda
    # itself
    pushd .
    cd
    mkdir -p download
    cd download
    echo "Cached in $HOME/download :"
    ls -l
    echo
    if [[ ! -f miniconda.sh ]]
        then
        if [[ "$PYTHON_VERSION" == "3.5" ]]; then
            wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
            -O miniconda.sh
        fi
    fi
    chmod +x miniconda.sh && ./miniconda.sh -b
    cd ..

    # Set conda command relative to miniconda version.
    if [[ "$PYTHON_VERSION" == "3.5" ]]; then
        export PATH=/home/travis/miniconda3/bin:$PATH
    fi

    conda update --yes conda
    popd

    # Configure the conda environment and put it in the path using the
    # provided versions
    conda create -n testenv --yes python=$PYTHON_VERSION numpy scipy coverage

    source activate testenv

    pip install scikit-learn==$SCIKIT_LEARN_VERSION
    pip install pandas
    pip install coveralls

    # Install nose-timer via pip
    pip install nose-timer

    python setup.py develop;
fi