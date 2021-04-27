## Sylvain SCHMITT
## 20/04/2021

import os
from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider
HTTP = HTTPRemoteProvider()

configfile: "config/config.yml"

rule all:
    input:
        "results/mutated_reference/mutation.tsv",
        expand("results/{foldertype}_reads_R{strand}.fastq", 
                foldertype=["base_reads1/base", "base_reads2/base", "mutated_reads/mixed"],
                strand=["1","2"])
        
# Rules

include: "rules/get_source.smk"
include: "rules/uncompress.smk"
include: "rules/index.smk"
include: "rules/reference_bed.smk"
include: "rules/sample_reference.smk"
include: "rules/generate_mutations.smk"
include: "rules/generate_reads.smk"
include: "rules/merge_reads.smk"
