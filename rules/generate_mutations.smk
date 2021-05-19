N=config["n_mut"]
R=config["R"]

rule generate_mutations:
    input:
        expand("results/reference/{seq}_{chr}.fa", seq=[config["sequence"]],  chr=[config["chr"]])
    output:
        expand("results/mutations/{seq}_{chr}_mutated_N{N}_R{R}.{ext}", 
                seq=config["sequence"], chr=config["chr"], ext=["tsv", "fa"], allow_missing=True)
    log:
        "results/logs/generate_mutations_N{N}_R{R}.log"
    benchmark:
        "results/benchmarks/generate_mutations_N{N}_R{R}.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/generate_mutations.R"
