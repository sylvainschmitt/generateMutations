#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH -J snaketest
#SBATCH -o snaketest.%N.%j.out
#SBATCH -e snaketest.%N.%j.err
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL
####SBATCH -p unlimitq

# Environment
module purge
module load bioinfo/snakemake-5.8.1
module load system/singularity-3.5.1

# Variables
CONFIG=config/genologin.yaml
COMMAND="sbatch --nodelist={cluster.nodelist} --mem={cluster.mem} --ntasks-per-node {cluster.npernode} -t {cluster.time} -n {cluster.ntasks} -c {cluster.c} -J {cluster.jobname} -o snake_subjob_log/{cluster.jobname}.%N.%j.out -e snake_subjob_log/{cluster.jobname}.%N.%j.err"
CORES=32
mkdir -p snake_subjob_log

# Workflow
snakemake -s Snakefile -n -r --use-singularity -j $CORES --cluster-config $CONFIG --cluster "$COMMAND"
snakemake -s Snakefile --report results/smk_report.html 

## Session informations
echo '########################################'
echo 'Date:' $(date --iso-8601=seconds)
echo 'User:' $USER
echo 'Host:' $HOSTNAME
echo 'Job Name:' $SLURM_JOB_NAME
echo 'Job ID:' $SLURM_JOB_ID
echo 'Array task ID:' ${SLURM_ARRAY_TASK_ID}
echo 'Number of nodes assigned to job:' $SLURM_JOB_NUM_NODES
echo 'Total number of cores for job (?):' $SLURM_NTASKS
echo 'Number of requested cores per node:' $SLURM_NTASKS_PER_NODE
echo 'Nodes assigned to job:' $SLURM_JOB_NODELIST
echo 'Directory:' $(pwd)
## Detail Information:
echo 'scontrol show job:'
scontrol show job $SLURM_JOB_ID
echo '########################################'
