rule generate_reads:
    input:
        temp("results/reads/sample.fa")
    output:
        "results/reads/reads"
    log:
        "results/logs/generate_reads.log"
    benchmark:
        "results/benchmarks/generate_reads.benchmark.txt"
    singularity: 
        "docker://hadrieng/insilicoseq:latest"
    shell:
        "iss generate --genomes {input} --model {config[illumina]} --n_reads {config[n_reads]} --cpus {threads} --o {output} --compress"
