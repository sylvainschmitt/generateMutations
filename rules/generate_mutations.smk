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
#    singularity:
#        "https://depot.galaxyproject.org/singularity/bioconductor-biostrings:2.58.0--r40hd029910_1"
# This fail and I don't know why, maybe I should build my own image
    script:
        "../scripts/generate_mutations.R"
