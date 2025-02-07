#!/bin/bash

# check environment-full.yml
ENV_YAML="$WORKSPACE/environment-full.yml"
if [ ! -f $ENV_YAML ]; then
    echo "$ENV_YAML is not found."
    exit 1
fi

conda config --show && \
conda config --set always_yes yes && \
conda clean -i && \
source scripts/install_pyrosys_conda.sh --dev --ci
