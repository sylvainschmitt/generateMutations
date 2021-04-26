rule reference_bed:
    output:
        "results/base_reference/base_reference.bed"
    log:
        "results/logs/reference_bed.log"
    benchmark:
        "results/benchmarks/reference_bed.benchmark.txt"
    shell:
        "echo '{config[reference][chromosome]}\t{config[reference][start]}\t{config[reference][stop]}' > results/base_reference/base_reference.bed"
