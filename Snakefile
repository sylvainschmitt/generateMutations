## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.dag.yml"

rule all:
    input:
        expand("results/trunk/trunk{ext}", ext=[".fa", "_snps.fa", "_snps.vcf", "_snps.map"]),
        expand("results/tips/B{branch}_T{condition}.{ext}", branch=config["branches"], condition=["L", "O"], ext=["tsv", "fa"]),
        expand("results/reads/B{branch}_T{condition}_R{strand}.fq", branch=config["branches"], condition=["L", "O"], strand=[1, 2])

# Rules

## Trunk ##
include: "rules/cp_ref.smk"
include: "rules/vcf2model.smk"
include: "rules/simug.smk"

## Branches ##
include: "rules/generate_mutations_branch.smk"
include: "rules/generate_mutations_tip.smk"

## Reads ##
include: "rules/iss_tips.smk"

