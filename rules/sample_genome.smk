rule sample_genome:
    input:
        expand("data/{genome}.fa", genome=config["genome"])
    output:
        expand("results/reference/{genome}_REP{REP,\d+}.fa", genome=config["genome"], allow_missing=True)
    log:
        "results/logs/sample_genome_REP{REP}.log"
    benchmark:
        "results/benchmarks/sample_genome_REP{REP}.benchmark.txt"
    singularity:
        "https://github.com/sylvainschmitt/singularity-tidyverse-Biostrings/releases/download/0.0.1/sylvainschmitt-singularity-tidyverse-Biostrings.latest.sif"
    script:
        "../scripts/sample_genome.R"
