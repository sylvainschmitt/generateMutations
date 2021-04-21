rule reference_subsample:
    input:
        "results/data/reference.sam.fa.gz"
    output:
        "results/data/sample.fa.gz"
    log:
        "results/logs/reference_subsample.log"
    benchmark:
        "results/benchmarks/reference_subsample.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input} {config[chromosome]} > {output}"
