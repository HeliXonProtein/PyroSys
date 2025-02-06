# Installation Guide

## Intall PyroSys From Source

For users who want the latest features and bug fixes, we recommend installing PyroSys from source.
Follow the steps below and happy coding!

### Prerequisites

Please make sure you have the following installed:

1. [Anaconda](https://docs.anaconda.com/anaconda/install/)

2. [nvidia-smi](https://docs.nvidia.com/deploy/nvidia-smi/index.html) (Optional for automatic CUDA version detection)

You can call
```bash
conda --version
```
to check if conda is installed.
We highly recommend using conda 23.10 or later as the default solver is [conda-libmamba-solver](https://conda.github.io/conda-libmamba-solver/user-guide/)
This solver is much faster than older version of conda.

### Install PyroSys

#### Auto CUDA Version Detection

We provide a automatic installation script for PyroSys.

```bash
source scripts/install_pyrosys_conda.sh
```
You can provide a specific python version by using the `--python` option. The default python version is from the `pyproject.toml` file.
If you are the developer of PyroSys, you can use the `--dev` option to install the dependencies for development and full ray support.
```bash
source scripts/install_pyrosys_conda.sh --dev
```

After this, you can install PyroSys by:
```bash
pip install -e.
```

#### Pure Manual Installation

We also provide a pure manual installation for PyroSys if you want to install some specific version of dependencies.
AFTER you have installed pytorch, you can install the dependencies by:

```bash
conda env update -f environment.yml
```
Or for developers:
```bash
conda env update -f environment-full.yml
```

Older version of Pytorch has not been tested, please be careful when using them.

After all this, you can install PyroSys by:
```bash
pip install -e.
```
