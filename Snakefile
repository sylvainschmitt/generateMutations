## Sylvain SCHMITT
## 20/04/2021

configfile: "config/config.yml"
# singularity: "img/snakemake_tuto.sif"

rule all:
    input:
        "data/sample.fa.gz"
        
rule reference_get:
    output:
        "data/reference.fa.gz"
    log:
        "logs/reference_get.log"
    benchmark:
        "benchmarks/reference_get.benchmark.txt"
    threads: 4
    shell:
        "wget {config[reference]} -O {output}"
        
rule reference_stats:
    input:
        "data/reference.fa.gz"
    output:
        "data/reference.stats.txt"
    log:
        "logs/reference_stat.log"
    benchmark:
        "benchmarks/reference_stat.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/bioawk/bioawk:latest"
    shell:
        "bioawk -c fastx '{{ print $name, length($seq) }}' < {input} > {output}"
        
rule reference_convert:
    input:
        "data/reference.fa.gz"
    output:
        "data/reference.sam.fa.gz"
    log:
        "logs/reference_convert.log"
    benchmark:
        "benchmarks/reference_convert.benchmark.txt"
    threads: 4
    shell:
        "zcat {input} | bgzip -c > {output}"
        
rule reference_index:
    input:
        "data/reference.fa.gz"
    log:
        "logs/reference_index.log"
    benchmark:
        "benchmarks/reference_index.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input}"

rule reference_subsample:
    input:
        "data/reference.sam.fa.gz"
    output:
        "data/sample.fa.gz"
    log:
        "logs/reference_subsample.log"
    benchmark:
        "benchmarks/reference_subsample.benchmark.txt"
    threads: 4
    singularity: 
        "oras://registry.forgemia.inra.fr/gafl/singularity/samtools/samtools:latest"
    shell:
        "samtools faidx {input} {config[chromosome]} > {output}"
