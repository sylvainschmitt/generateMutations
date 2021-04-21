rule reference_index:
    input:
        "results/data/reference.fa.gz"
    log:
        "results/logs/reference_index.log"
    benchmark:
        "results/benchmarks/reference_index.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input}"
        