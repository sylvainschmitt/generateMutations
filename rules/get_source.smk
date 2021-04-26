rule get_source:
    input:
        HTTP.remote(
                    expand("{address}{files}.gz", 
                            address=config["genome"]["address"],
                            files=[config["genome"]["sequence"], config["genome"]["genes"], config["genome"]["TE"]]),
                    keep_local=True)
    output:
        protected(expand("results/source/{files}.gz", 
                        files=[config["genome"]["sequence"], config["genome"]["genes"], config["genome"]["TE"]]))
    log:
        "results/logs/get_source.log"
    benchmark:
        "results/benchmarks/get_source.benchmark.txt"
    shell:
        "mv {input} {output}"
              