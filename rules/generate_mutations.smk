rule generate_mutations:
    input:
        expand("results/reference/{genome}_REP{REP}.fa", genome=config["genome"], allow_missing=True)
    output:
        expand("results/mutations/{genome}_REP{REP}_mutated_N{N}_R{R}.{ext}", 
                genome=config["genome"], ext=["tsv", "fa"], allow_missing=True)
    log:
        "results/logs/generate_mutations_REP{REP}_N{N}_R{R}.log"
    benchmark:
        "results/benchmarks/generate_mutations_REP{REP}_N{N}_R{R}.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/generate_mutations.R"
