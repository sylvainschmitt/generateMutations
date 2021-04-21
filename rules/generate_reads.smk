rule generate_reads:
    input:
        "results/data/sample.fa"
    output:
        temp("results/reads/reads_R1.fastq.gz"),
        temp("results/reads/reads_R2.fastq.gz"),
        temp("results/reads/reads_abundance.txt")
    log:
        "results/logs/generate_reads.log"
    benchmark:
        "results/benchmarks/generate_reads.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    shell:
        "iss generate --genomes {input} --model {config[illumina]} --n_reads {config[n_reads]} --cpus {threads} --o results/reads/reads --compress"
