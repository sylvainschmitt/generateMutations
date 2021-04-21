rule chromosomes_length:
    input:
        "results/data/genome.fa.gz"
    output:
        "results/data/chromosomes_length.txt"
    log:
        "results/logs/chromosomes_length.log"
    benchmark:
        "results/benchmarks/chromosomes_length.benchmark.txt"
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/bioawk/bioawk:latest"
    shell:
        "bioawk -c fastx '{{ print $name, length($seq) }}' < {input} > {output}"
