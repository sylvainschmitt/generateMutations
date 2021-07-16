rule cp_ref:
    input:
        expand("data/{seq}.fa", seq=[config["sequence"]])
    output:
        "results/trunk/trunk.fa"
    log:
        "results/logs/cp_ref.log"
    benchmark:
        "results/benchmarks/cp_ref.benchmark.txt"
    shell:
        "cp {input} {output}"
