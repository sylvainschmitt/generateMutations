rule generate_mutations_branch:
    input:
        "results/trunk/trunk.fa"
    output:
        expand("results/branch/B{branch}.{ext}", ext=["tsv", "fa"], allow_missing=True)
    log:
        "results/logs/generate_mutations_branch_{branch}.log"
    benchmark:
        "results/benchmarks/generate_mutations_branch_{branch}.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/generate_mutations.R"
