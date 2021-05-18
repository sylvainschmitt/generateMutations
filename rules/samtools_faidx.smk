rule samtools_faidx:
    input:
        expand("results/source/{seq}.fa", seq=[config["sequence"]])
    output:
        expand("results/reference/{seq}_{chr}.fa", seq=[config["sequence"]],  chr=[config["chr"]])
    log:
        "results/logs/samtools_faidx.log"
    benchmark:
        "results/benchmarks/samtools_faidx.benchmark.txt"
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input} {config[chr]} -o {output} ; rm {input}.fai"
