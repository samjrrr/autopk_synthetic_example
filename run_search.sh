#!/bin/bash
# Slurm arguments
#SBATCH -c 40
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-72:00:00     # 120 minutes

# Load modules
echo "Loading modules"
module load Miniconda3/4.12.0
module load nonmem-standard/7.5.0-gmpich-2019a
# source activate dar1

# Run PyDarwin
pydarwin_dir=/projects/qcp/QCP_MODELING/OTHER/autoPK/automatization_popPK/poppk/az_synthetic_data/ribo/8/5/n0/
export PYTHONPATH=$PYTHONPATH:/home/kfdw240/code/packages/pyDarwin2/pyDarwin/src

echo "Running PyDarwin on synthetic data"
/home/kfdw240/.conda/envs/pydar2/bin/python -m darwin.run_search ${pydarwin_dir}template.txt ${pydarwin_dir}tokens.json ${pydarwin_dir}options.json