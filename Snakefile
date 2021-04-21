## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.yml"

rule all:
    input:
      "results/data/reference.stats.txt",
      "results/data/sample.fa.gz"
        
include: "rules/reference_get.smk"
include: "rules/reference_stats.smk"
include: "rules/reference_convert.smk"
include: "rules/reference_index.smk"
include: "rules/reference_subsample.smk"
