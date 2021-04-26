rule index_source:
    input:
        expand("results/source/{file}", file=config["genome"]["sequence"])
    output:
        expand("results/source/{file}.fai", file=config["genome"]["sequence"])
    log:
        "results/logs/index_reference.log"
    benchmark:
        "results/benchmarks/index_reference.benchmark.txt"
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input}"
