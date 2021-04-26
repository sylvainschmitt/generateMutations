## Sylvain SCHMITT
## 20/04/2021

import os
from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider
HTTP = HTTPRemoteProvider()

configfile: "config/config.yml"

rule all:
    input:
        "results/base_reference/base_reference.fa",
        "results/mutated_reference/mutation.tsv",
        "results/mutated_reference/mutated_reference.fa"
        
# Rules

include: "rules/get_source.smk"
include: "rules/uncompress_source.smk"
include: "rules/index_source.smk"
include: "rules/reference_bed.smk"
include: "rules/sample_reference.smk"
include: "rules/generate_mutations.smk"
