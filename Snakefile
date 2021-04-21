## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.yml"

rule all:
    input:
      "results/data/chromosomes_length.txt",
      "results/reads/normal_R1.fastq.gz",
      "results/reads/normal_R2.fastq.gz",
      "results/reads/premutated_R1.fastq.gz",
      "results/reads/premutated_R2.fastq.gz"
        
# Reference

include: "rules/get_genome.smk"
include: "rules/chromosomes_length.smk"
include: "rules/sample_reference.smk"
include: "rules/uncompress_reference.smk"
include: "rules/generate_reads.smk"
include: "rules/split_reads.smk"
