#!/bin/bash
#step 1
# install_rapids_polaris.sh
# Install RAPIDS on Polaris
# First, run this script to create a conda environment, then activate the environment by running the script 'activate_rapids_env_polaris.sh (step 2)'
SYSTEM="polaris"
RAPIDS_VERSION=23.04
CUDATOOLKIT_VERSION=11.8
PYTHON_VERSION=3.10
ENV_PATH="/path/to/conda/dir"
BASE_CONDA=2022-09-08
RAPIDS_WORKDIR='~'

module load conda/${BASE_CONDA} && \
conda create -y -p ${ENV_PATH}/rapids-${RAPIDS_VERSION}_${SYSTEM} \
-c rapidsai -c nvidia -c conda-forge rapids=${RAPIDS_VERSION} \
python=${PYTHON_VERSION} cudatoolkit=${CUDATOOLKIT_VERSION} \
ipykernel jupyterlab-nvdashboard dask-labextension && \
conda activate ${ENV_PATH}/rapids-${RAPIDS_VERSION}_${SYSTEM} && \
jupyter serverextension enable --py --sys-prefix dask_labextension && \
env=$(basename `echo $CONDA_PREFIX`) && \
python -m ipykernel install --user --name "$env" --display-name "Python [conda env:"$env"]"

cat > activate_rapids_env_polaris.sh << EOF
#!/bin/bash
module load conda/${BASE_CONDA} && \
conda activate ${ENV_PATH}/rapids-${RAPIDS_VERSION}_${SYSTEM} && \
\$@
EOF
