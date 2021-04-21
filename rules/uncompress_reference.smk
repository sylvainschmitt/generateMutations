rule uncompress_reference:
    input:
        "results/data/sample.fa.gz"
    output:
        temp("results/reads/sample.fa")
    log:
        "results/logs/uncompress_reference.log"
    benchmark:
        "results/benchmarks/uncompress_reference.benchmark.txt"
    shell:
        "zcat {input} > {output}"
