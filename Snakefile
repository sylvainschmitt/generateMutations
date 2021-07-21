## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.dag.yml"

rule all:
    input:
        expand("results/trunk/trunk{ext}", ext=[".fa", "_snps.vcf"]), # genome
        expand("results/reads/trunk_C{cambium}_R{strand}.fq", cambium=config["cambiums"], strand=[1, 2]), # cambium
        expand("results/reads/B{branch}_T{tip}_L{leaf}_R{strand}.fq", 
                branch=config["branches"], tip=config["tips"], leaf=config["leaves"], strand=[1, 2]) # leaves
        

# Rules

## Cambiums ##
include: "rules/cp_ref.smk"
include: "rules/vcf2model.smk"
include: "rules/simug.smk"
include: "rules/iss_cambium.smk"

## Leaves ##
include: "rules/generate_mutations_branch.smk"
include: "rules/generate_mutations_tip.smk"
include: "rules/iss_leaf.smk"
