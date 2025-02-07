#!/bin/bash

# check environment-full.yml
ENV_PREFIX="$WORKSPACE/env"
ENV_YAML="$WORKSPACE/environment-full.yml"
ENV_CACHE_YAML="$WORKSPACE/env/environment-full.yml"
if [ ! -f $ENV_YAML ]; then
    echo "$ENV_YAML is not found."
    exit 1
fi

# update env
if diff --brief <(cat $ENV_CACHE_YAML 2>/dev/null) <(cat $ENV_YAML); then
    echo "Environment is up to date"
else
    if [ -d ./env ]; then
        echo "Environment is out of date, removing old environment"
        rm -rf ./env
    fi
    echo "Creating new environment"

    conda config --show && \
    conda config --set always_yes yes && \
    conda clean -i && \
    conda env create -p $ENV_PREFIX -f $ENV_YAML && \
    conda activate $ENV_PREFIX && \
    source scripts/install_pyrosys_conda.sh --dev --ci && \
    cp $ENV_YAML $ENV_CACHE_YAML
fi
