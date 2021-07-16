rule generate_mutations_branch:
    input:
        expand("results/reference/{seq}.fa", seq=[config["sequence"]])
    output:
        expand("results/branches/B{branch}.{ext}", ext=["tsv", "fa"], allow_missing=True)
    log:
        "results/logs/generate_mutations_branch_{branch}.log"
    benchmark:
        "results/benchmarks/generate_mutations_branch_{branch}.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/generate_mutations.R"
