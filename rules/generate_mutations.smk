rule generate_mutations:
    input:
        "results/base_reference/base_reference.bed",
        "results/base_reference/base_reference.fa"
    output:
        "results/mutated_reference/mutation.tsv",
        "results/mutated_reference/mutated_reference.fa"
    log:
        "results/logs/generate_mutations.log"
    benchmark:
        "results/benchmarks/generate_mutations.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/generate_mutations.R"
