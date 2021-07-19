rule generate_mutations_tip:
    input:
        "results/branch/B{branch}.fa"
    output:
        expand("results/tips/B{branch}_T{tip}.{ext}", ext=["tsv", "fa"], allow_missing=True)
    log:
        "results/logs/generate_mutations_tip_B{branch}_T{tip}.log"
    benchmark:
        "results/benchmarks/generate_mutations_tip_B{branch}_T{tip}.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/generate_mutations.R"
