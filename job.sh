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

# Variables
CONFIG=config/genologin.yaml
#COMMAND="sbatch --nodelist={cluster.nodelist} --mem={cluster.mem} --ntasks-per-node {cluster.npernode} -t {cluster.time} -n {cluster.ntasks} -c {cluster.c} -J {cluster.jobname} -o snake_subjob_log/{cluster.jobname}.%N.%j.out -e snake_subjob_log/{cluster.jobname}.%N.%j.err"
COMMAND="sbatch -p unlimitq --cpus-per-task={cluster.cpus} --time={cluster.time} --mem={cluster.mem} -J {cluster.jobname} -o snake_subjob_log/{cluster.jobname}.%N.%j.out -e snake_subjob_log/{cluster.jobname}.%N.%j.err"
# from https://forgemia.inra.fr/bios4biol/workflows/-/blob/06c6a5cb3206a594f9a535ba8d3df3e64682a8bc/Snakemake/template_dev/test_SLURM.sh
CORES=32
mkdir -p snake_subjob_log

# Workflow
snakemake -s Snakefile --use-singularity -j $CORES --cluster-config $CONFIG --cluster "$COMMAND"
# snakemake -s Snakefile --report results/smk_report.html lack jinja2

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
## Detail Information:
#echo 'scontrol show job:'
#scontrol show job $SLURM_JOB_ID
echo '########################################'
