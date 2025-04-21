#!/usr/bin/env bash
set -e
echo "PyWrap installer — Linux/macOS"

PYTHON_VERSION=${1:-3.12}
R_VERSION=${2:-4.3}

echo "➡ Installing Python $PYTHON_VERSION with miniconda..."
if ! command -v conda >/dev/null; then
  echo "Conda not found. Installing Miniconda..."
  curl -sSLo miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  bash miniconda.sh -b -p $HOME/miniconda
  eval "$($HOME/miniconda/bin/conda shell.bash hook)"
fi

conda create -y -n pywrap python=$PYTHON_VERSION numpy pandas
echo "Activate with:  conda activate pywrap"
echo "Exporting PYTHON_LIBRARY..."
echo "export PYTHON_LIBRARY=$CONDA_PREFIX/lib/libpython${PYTHON_VERSION}.so" > pywrap_env.sh
echo "Done ✅"
