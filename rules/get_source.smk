file=[config["genome"]["sequence"], config["genome"]["genes"], config["genome"]["TE"]]

rule get_source:
    input:
        HTTP.remote("urgi.versailles.inra.fr/download/oak/{file}.gz", keep_local=True)
    output:
        protected("results/source/{file}.gz")
    log:
        "results/logs/get_{file}.log"
    benchmark:
        "results/benchmarks/get_{file}.benchmark.txt"
    shell:
        "mv {input} {output}"