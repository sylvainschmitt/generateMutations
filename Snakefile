## Sylvain SCHMITT
## 20/04/2021

# configfile: "config/config.yml"
configfile: "config/config.dag.yml"

rule all:
    input:
        expand("results/reference/{seq}_{chr}{ext}", seq=config["sequence"],  chr=config["chr"], 
                ext=[".fa", "_snps.fa", "_snps.vcf", "_snps.map"]),
        expand("results/mutation_N{N}_R{R}/{seq}_{chr}_mutated_N{N}_R{R}.{ext}", 
                seq=config["sequence"], chr=config["chr"], ext=["tsv", "fa"], N=config["n_mut"], R=config["R"]),
        # expand("results/reads_N{N}_R{R}_AF{AF}_NR{NR}/{type}", file=["_R1.fastq", "_R2.fastq"], 
        #         N=config["n_mut"], R=config["R"], AF=config["AF"], NR=config["n_reads"], type=["mutated", "base"])
        expand("results/reads_N{N}_R{R}_AF{AF}_NR{NR}/mixed_R{strand}.fastq", 
                N=config["n_mut"], R=config["R"], AF=config["AF"], NR=config["n_reads"], strand=["1","2"])

# Rules

include: "rules/cp_files.smk"
include: "rules/samtools_faidx.smk"
include: "rules/vcf2model.smk"
include: "rules/simug.smk"
include: "rules/generate_mutations.smk"
include: "rules/iss_base.smk"
include: "rules/iss_mutated.smk"
include: "rules/merge_reads.smk"
