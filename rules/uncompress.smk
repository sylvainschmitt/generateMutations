files=[config["genome"]["sequence"], config["genome"]["genes"], config["genome"]["TE"]]

rule uncompress:
    input:
        "results/source/{files}.gz"
    output:
        "results/source/{files}"
    log:
        "results/logs/uncompress_{files}.log"
    benchmark:
        "results/benchmarks/uncompress_{files}.benchmark.txt"
    shell:
        "zcat {input} > {output}"
