#!/bin/bash
# Step 2
#activate_rapids_env_polaris.sh
#After running the 'install_rapids_polaris.sh' script, run this script next to activate conda 
module use /soft/modulefiles && module load conda/2024-04-29 && conda activate /lus/eagle/clone/g2/projects/datascience/rapids/polaris/rapids-23.04_polaris && $@

