rule split_reads:
    input:
        "results/reads/reads_R1.fastq.gz",
        "results/reads/reads_R2.fastq.gz"
    output:
        "results/reads/normal_R1.fastq.gz",
        "results/reads/normal_R2.fastq.gz",
        "results/reads/premutated_R1.fastq.gz",
        "results/reads/premutated_R2.fastq.gz"
    log:
        "results/logs/split_reads.log"
    benchmark:
        "results/benchmarks/split_reads.benchmark.txt"
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/seqkit/seqkit:latest"
    shell:
        "seqkit split2 -p 2 -1 {input[0]} -2 {input[1]} -O results/reads ; "
        "mv results/reads/reads_R1.part_001.fastq.gz results/reads/normal_R1.fastq.gz ; "
        "mv results/reads/reads_R2.part_001.fastq.gz results/reads/normal_R2.fastq.gz ; "
        "mv results/reads/reads_R1.part_002.fastq.gz results/reads/premutated_R1.fastq.gz ; "
        "mv results/reads/reads_R2.part_002.fastq.gz results/reads/premutated_R2.fastq.gz"
