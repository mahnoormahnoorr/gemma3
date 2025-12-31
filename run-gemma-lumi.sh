#!/bin/bash
#SBATCH --account=project_462000131
#SBATCH --partition=dev-g
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=7
#SBATCH --gpus-per-node=1
#SBATCH --mem=32G
#SBATCH --time=00:30:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

# Load the module
module purge
module use /appl/local/csc/modulefiles
module load pytorch/2.7

# Ensure HF auth inside the container/job
export HF_TOKEN=$(cat /users/mmahnoor/.cache/huggingface/token)
export HUGGINGFACE_HUB_TOKEN="$HF_TOKEN"
export HF_HOME=/pfs/lustrep4/scratch/project_462000131/mmahnoor/hf_home
export TRANSFORMERS_CACHE=$HF_HOME/transformers
export HF_HUB_CACHE=$HF_HOME/hub

# Activate the virtual environment from your current directory or change to the appropriate path
source venv/bin/activate

# This will store all the Hugging Face cache such as downloaded models
# and datasets in the project's scratch folder
export HF_HOME=/scratch/${SLURM_JOB_ACCOUNT}/${USER}/hf-cache
mkdir -p $HF_HOME

srun python3 main.py
