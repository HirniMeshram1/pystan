#!/bin/bash
# This script is meant to be called by the "install" step defined in
# .travis.yml. See http://docs.travis-ci.com/ for more details.
# The behavior of the script is controlled by environment variables defined
# in the .travis.yml in the top level folder of the project.

set -e

# steps common to linux and OS X

# use Anaconda to get compiled versions of scipy and numpy,
# modified from https://gist.github.com/dan-blanchard/7045057
if [[ `uname -m` == 'aarch64' ]]; then 
    wget https://github.com/conda-forge/miniforge/releases/download/4.8.2-1/Miniforge3-4.8.2-1-Linux-aarch64.sh -O miniconda.sh; 
    chmod +x miniconda.sh
    ./miniconda.sh -b -p $HOME/miniconda3
fi
if [[ `uname -m` == 'x86_64' ]]; then 
    wget https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh -O miniconda.sh; 
    chmod +x miniconda.sh
    ./miniconda.sh -b 
fi
export PATH=$HOME/miniconda3/bin:$PATH
# Update conda itself
conda update --yes --quiet conda
PYTHON_VERSION_MAJOR=${TRAVIS_PYTHON_VERSION:0:1}
echo $TRAVIS_PYTHON_VERSION
echo "#################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo $PYTHON_VERSION_MAJOR
ENV_NAME="${TRAVIS_OS_NAME}_${CC}_py${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}"
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%"
echo $ENV_NAME
echo "??????????????????????????????????????????????????????????????????"
echo $PYTHON_VERSION_MINOR
if [[ $PYTHON_VERSION_MAJOR == '2' ]]; then conda create --quiet --yes -n test-environment python=$TRAVIS_PYTHON_VERSION pip Cython=0.22 numpy=1.10.1 scipy nose matplotlib pandas; fi
if [[ $PYTHON_VERSION_MAJOR == '3' ]]; then conda create --quiet --yes -n test-environment python=$TRAVIS_PYTHON_VERSION pip Cython numpy scipy nose matplotlib pandas; fi
source activate test-environment
python3 -c "import numpy"

# run quietly due to travis ci's log limit
python3 setup.py -q install
