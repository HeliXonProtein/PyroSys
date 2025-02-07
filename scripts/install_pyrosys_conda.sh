#!/bin/bash
# Install PyroSys based on your CUDA version

set -e # Exit if any command fails.

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "Conda is not installed. Please install conda before running this script."
    exit 1
fi

# Extract Python version from pyproject.toml
if [ -f pyproject.toml ]; then
    PYTHON_VERSION=$(awk -F'[">= ]+' '/requires-python/{print $2}' pyproject.toml)
    if [ -z "$PYTHON_VERSION" ]; then
        echo "Failed to extract Python version from pyproject.toml"
        exit 1
    fi
else
    echo "pyproject.toml not found"
    exit 1
fi

# Default values
ENV_NAME=${env_name:-pyrosys}
DEV_MODE=${dev_mode:-0}
CI_MODE=${ci_mode:-0}

# Detect CUDA version
if [ "$CI_MODE" -eq 0 ]; then
    if command -v nvidia-smi &> /dev/null; then
        DRIVER_VERSION=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n 1 | cut -d'.' -f1)
    else
        echo "CUDA is not installed. Please install CUDA before running this script."
        exit 1
    fi
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --python)
        echo "WARNING: Manually setting Python version is not recommended and should only be used for legacy CUDA compatibility."
        echo "The recommended Python version from pyproject.toml is $PYTHON_VERSION"
        PYTHON_VERSION="$2"
        shift 2
        ;;
        --env-name)
        ENV_NAME="$2"
        shift 2
        ;;
        --dev)
        DEV_MODE=1
        shift
        ;;
        --ci)
        CI_MODE=1
        shift
        ;;
        *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ "$CI_MODE" -eq 0 ]; then
    echo "Welcome to PyroSys installation script!"
    conda config --set always_yes yes
    conda create -y -n $ENV_NAME python=$PYTHON_VERSION
    conda activate $ENV_NAME
    # Install Pytorch based on CUDA version
    if [ "$DRIVER_VERSION" -ge 535 ]; then
        conda install -y pytorch==2.5.0 pytorch-cuda=12.1 -c pytorch -c nvidia
    else
        echo "Unsupported CUDA version. Please install CUDA 12.1 or later."
        exit 1
    fi
else
    echo "CI mode installation, skip GPU based Pytorch installation"
    conda install -y pytorch cpuonly -c pytorch
fi

# Install Other Dependencies
if [ "$DEV_MODE" -eq 0 ]; then
    conda env update -f environment.yml
elif [ "$CI_MODE" -eq 1 ]; then
    conda env update -f environment-full.yml -q
else
    conda env update -f environment-full.yml
fi

echo "PyroSys conda environment is ready!"
