#!/bin/bash 
#SBATCH -q debug
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH -J ilamb_job
#SBATCH -o ilamb_job.o%j
#SBATCH -L SCRATCH,project


mdoule list
conda info --envs
source /global/homes/m/minxu/MyGit/ilamb-venv/activate_ilamb_venv.sh
export ILAMB_ROOT=/global/cscratch1/sd/minxu/ILAMB2_WCYCLE/ILAMB_ROOT
cd $ILAMB_ROOT
srun -n 8 ilamb-run --model_root MODEL --config ilamb.cfg --regions global bona tena ceam nhsa shsa euro mide nhaf shaf boas ceas seas eqas aust
