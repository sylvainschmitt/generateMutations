# 4 generations: 2 base in seperated folders to test specificity and 1 base and 1 mutated in one mutated folder

type=["base", "base", "base", "mutated"]
folder=["base_reads1", "base_reads2", "mutated_reads", "mutated_reads"]

rule generate_reads:
    input:
        "results/{type}_reference/{type}_reference.fa"
    output:
        "results/{folder}/{type}_reads_R1.fastq",
        "results/{folder}/{type}_reads_R2.fastq",
        temp("results/{folder}/{type}_reads_abundance.txt")
    params:
        F = "{folder}",
        T = "{type}"
    log:
        "results/logs/generate_reads_{folder}_{type}.log"
    benchmark:
        "results/benchmarks/generate_reads_{folder}_{type}.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    shell:
        "iss generate --genomes {input} --model {config[sequencing][illumina]} --n_reads {config[sequencing][n_reads]} --cpus {threads} --o results/{params.F}/{params.T}_reads"
