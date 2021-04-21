rule reference_stats:
    input:
        "results/data/reference.fa.gz"
    output:
        "results/data/reference.stats.txt"
    log:
        "results/logs/reference_stat.log"
    benchmark:
        "results/benchmarks/reference_stat.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/bioawk/bioawk:latest"
    shell:
        "bioawk -c fastx '{{ print $name, length($seq) }}' < {input} > {output}"
