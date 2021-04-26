files=[config["genome"]["sequence"], config["genome"]["genes"], config["genome"]["TE"]]

rule uncompress_source:
    input:
        "results/source/{files}.gz"
    output:
        "results/source/{files}"
    log:
        "results/logs/uncompress_source_{files}.log"
    benchmark:
        "results/benchmarks/uncompress_source_{files}.benchmark.txt"
    shell:
        "zcat {input} > {output}"
