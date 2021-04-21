## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.yml"

rule all:
    input:
      "results/data/chromosomes_length.txt",
      "results/reads/reads"
        
# Reference

include: "rules/get_genome.smk"
include: "rules/chromosomes_length.smk"
include: "rules/sample_reference.smk"
include: "rules/uncompress_reference.smk"
include: "rules/generate_reads.smk"
