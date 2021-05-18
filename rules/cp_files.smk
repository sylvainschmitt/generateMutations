files=[config["sequence"] + ".fa", config["genes"], config["TE"], config["hz"]]

rule cp_files:
    input:
        "data/{files}"
    output:
        temp("results/source/{files}")
    log:
        "results/logs/cp_{files}.log"
    benchmark:
        "results/benchmarks/cp_{files}.benchmark.txt"
    shell:
        "cp {input} {output}"
