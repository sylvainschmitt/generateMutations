rule reference_get:
    output:
        "results/data/reference.fa.gz"
    log:
        "results/logs/reference_get.log"
    benchmark:
        "results/benchmarks/reference_get.benchmark.txt"
    threads: 4
    shell:
        "wget {config[reference]} -O {output}"
        