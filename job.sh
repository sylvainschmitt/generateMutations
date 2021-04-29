#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH -J genMut
#SBATCH -o genMut.%N.%j.out
#SBATCH -e genMut.%N.%j.err
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=ALL
####SBATCH -p unlimitq

# Environment
module purge
module load bioinfo/snakemake-5.8.1
module load system/singularity-3.6.4
# module load system/Python-3.6.3 # for jinja2 # bug with singularity

# Variables
CONFIG=config/genologin.yaml
COMMAND="sbatch -p unlimitq --cpus-per-task={cluster.cpus} --time={cluster.time} --mem={cluster.mem} -J {cluster.jobname} -o snake_subjob_log/{cluster.jobname}.%N.%j.out -e snake_subjob_log/{cluster.jobname}.%N.%j.err"
CORES=32
mkdir -p snake_subjob_log

# Workflow
snakemake -s Snakefile --use-singularity -j $CORES --cluster-config $CONFIG --cluster "$COMMAND"
# snakemake -s Snakefile --report results/smk_report.html

## Session informations
echo '########################################'
echo 'Date:' $(date --iso-8601=seconds)
echo 'User:' $USER
echo 'Host:' $HOSTNAME
echo 'Job Name:' $SLURM_JOB_NAME
echo 'Job ID:' $SLURM_JOB_ID
echo 'Number of nodes assigned to job:' $SLURM_JOB_NUM_NODES
echo 'Nodes assigned to job:' $SLURM_JOB_NODELIST
echo 'Directory:' $(pwd)
echo '########################################'
