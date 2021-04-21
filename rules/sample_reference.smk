rule sample_reference:
    input:
        "results/data/genome.fa.gz"
    output:
        "results/data/sample.fa.gz"
    log:
        "results/logs/sample_reference.log"
    benchmark:
        "results/benchmarks/sample_reference.benchmark.txt"
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/seqkit/seqkit:latest"
    shell:
        "seqkit grep -i -r -p '{config[chromosome]}' {input} -o {output}"
