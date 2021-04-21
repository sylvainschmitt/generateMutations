rule get_genome:
    output:
        "results/data/genome.fa.gz"
    log:
        "results/logs/get_genome.log"
    benchmark:
        "results/benchmarks/get_genome.benchmark.txt"
    shell:
        "wget {config[genome]} -O {output}"
        